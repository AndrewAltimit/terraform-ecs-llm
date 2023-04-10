
resource "aws_security_group" "ecs_tasks_sg" {
  name        = "ecs_tasks_sg"
  description = "Allow inbound traffic from the ALB"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
}


resource "aws_ecs_task_definition" "this" {
  family                   = "${local.app_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "${local.app_name}-container"
      image = var.ecs_image

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-region"        = "us-east-1"
          "awslogs-group"         = "/ecs/${local.app_name}-task"
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = [
        {
          name  = "S3_BUCKET"
          value = var.bucket_name
        }
      ]

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  name            = "${local.app_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.primary.id]
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "${local.app_name}-container"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.this]
}
