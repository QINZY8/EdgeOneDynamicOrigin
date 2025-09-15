# 基础镜像
FROM python:alpine3.20

# 设置工作目录
WORKDIR /app

# 复制依赖文件
COPY requirements.txt ./

# 更换为USTC镜像源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

# 安装系统依赖
RUN apk update && \
    apk add --no-cache \
    gcc \
    python3-dev \
    musl-dev \
    linux-headers \
    py3-psutil

# 配置时区
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

# 设置 pip 使用USTC镜像源
RUN pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple

# 安装依赖
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 复制项目代码
COPY src ./src
COPY README.md ./
COPY img.png ./

# 设置环境变量（可选）
ENV PYTHONUNBUFFERED=1

# 暴露端口
EXPOSE 54321

# 启动命令
CMD ["python", "src/eodo/app.py", "-p", "54321"]