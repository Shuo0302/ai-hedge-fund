#!/bin/bash

# 显示彩色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}开始安装 AI Hedge Fund 项目依赖...${NC}"

# 检查 Python 版本
echo -e "${YELLOW}检查 Python 版本...${NC}"
python_version=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
# 将版本号转换为数字（例如：3.12 -> 312）
version_number=$(echo $python_version | tr -d '.')
required_version_number=39

if [ $version_number -lt $required_version_number ]; then
    echo -e "${YELLOW}需要 Python 3.9 或更高版本，当前版本: $python_version${NC}"
    exit 1
else
    echo -e "${GREEN}Python 版本检查通过: $python_version${NC}"
fi

# 安装 Poetry
echo -e "${YELLOW}安装 Poetry...${NC}"
if ! command -v poetry &> /dev/null; then
    curl -sSL https://install.python-poetry.org | python3 -
    # 添加 Poetry 到 PATH
    export PATH="$HOME/.local/bin:$PATH"
else
    echo -e "${GREEN}Poetry 已经安装${NC}"
fi

# 配置 Poetry
echo -e "${YELLOW}配置 Poetry...${NC}"
poetry config virtualenvs.in-project true

# 安装项目依赖
echo -e "${YELLOW}安装项目依赖...${NC}"
poetry install

# 创建环境变量文件
echo -e "${YELLOW}创建环境变量文件...${NC}"
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${YELLOW}请编辑 .env 文件，添加必要的 API 密钥${NC}"
fi

echo -e "${GREEN}安装完成！${NC}"
echo -e "${YELLOW}请确保您已经：${NC}"
echo -e "1. 编辑了 .env 文件并添加了必要的 API 密钥"
echo -e "2. 至少配置了以下 API 密钥之一："
echo -e "   - OPENAI_API_KEY"
echo -e "   - GROQ_API_KEY"
echo -e "   - ANTHROPIC_API_KEY"
echo -e "   - DEEPSEEK_API_KEY"
echo -e "3. 如果需要分析非免费股票，请配置 FINANCIAL_DATASETS_API_KEY"

echo -e "${GREEN}要运行项目，请使用以下命令：${NC}"
echo -e "poetry run python src/main.py --ticker AAPL,MSFT,NVDA" 
