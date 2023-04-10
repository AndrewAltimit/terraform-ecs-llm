import os
import argparse
from cloudpathlib import CloudPath

# Given a model path on s3, download it locally to be used by the AI web server
def download_model(model_path, bucket, path):
    model_name = model_path.split("/")[-1]
    s3_model = CloudPath(f"s3://{bucket}/{model_path}/")
    s3_model.download_to(f"{path}/{model_name}")

if __name__ == "__main__":
    # Parse Arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', type=str, required=True, help="Example: models/chavinlo_gpt4-x-alpaca")
    parser.add_argument('--bucket', type=str, required=True, help="Example: mybucket")
    parser.add_argument('--path', type=str, default='/text-generation-webui', required=False, help="Example: /text-generation-webui")
    args = parser.parse_args()

    # Download Models
    download_model(model_path=args.model, bucket=args.bucket path=args.path)

    # Start Web Server
    os.system(f"python {args.path}/server.py --auto-devices --cai-chat")
