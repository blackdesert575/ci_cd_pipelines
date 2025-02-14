import argparse
import subprocess
import sys

def run_command(command):
    """執行 Shell 命令，並即時顯示輸出"""
    process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    for line in process.stdout:
        print(line, end="")

    stderr_output = process.stderr.read()
    if process.wait() != 0:
        print(f"❌ 命令執行失敗: {stderr_output}", file=sys.stderr)
        sys.exit(1)

def build_docker_image(image_name, dockerfile_path="."):
    """構建 Docker 映像"""
    print(f"🚀 開始構建 {image_name} ...")
    command = ["docker", "build", "-t", image_name, dockerfile_path]
    run_command(command)
    print("✅ 構建完成！")

def push_docker_image(image_name):
    """推送 Docker 映像"""
    print(f"📤 推送 {image_name} 到 Docker Hub ...")
    command = ["docker", "push", image_name]
    run_command(command)
    print("✅ 推送成功！")

def copy_docker_image(source, destination):
    """使用 skopeo 複製 Docker 映像"""
    print(f"🔄 使用 skopeo 複製 {source} 到 {destination} ...")
    command = ["skopeo", "copy", f"docker://{source}", f"docker://{destination}"]
    run_command(command)
    print("✅ 映像複製成功！")

def main():
    parser = argparse.ArgumentParser(description="Docker & Skopeo CLI 工具")

    subparsers = parser.add_subparsers(dest="command", required=True)

    # build 命令
    parser_build = subparsers.add_parser("build", help="構建 Docker 映像")
    parser_build.add_argument("image", help="Docker 映像名稱 (e.g., myrepo/myapp:latest)")
    parser_build.add_argument("--path", default=".", help="Dockerfile 路徑 (默認為當前目錄)")

    # push 命令
    parser_push = subparsers.add_parser("push", help="推送 Docker 映像")
    parser_push.add_argument("image", help="Docker 映像名稱 (e.g., myrepo/myapp:latest)")

    # copy 命令
    parser_copy = subparsers.add_parser("copy", help="使用 skopeo 複製 Docker 映像")
    parser_copy.add_argument("source", help="來源 Docker Registry 映像 (e.g., docker.io/myrepo/myapp:latest)")
    parser_copy.add_argument("destination", help="目標 Docker Registry 映像 (e.g., registry.example.com/myapp:latest)")

    args = parser.parse_args()

    if args.command == "build":
        build_docker_image(args.image, args.path)
    elif args.command == "push":
        push_docker_image(args.image)
    elif args.command == "copy":
        copy_docker_image(args.source, args.destination)

if __name__ == "__main__":
    main()