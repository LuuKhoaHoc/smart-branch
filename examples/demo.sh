#!/bin/bash

# Demo script để test AI integration
# Usage: ./demo.sh

echo "🎬 === Demo AI Git Branch Creator ==="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_SCRIPT="$SCRIPT_DIR/create-branch-ai.sh"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# Check if AI script exists
if [[ ! -f "$AI_SCRIPT" ]]; then
    echo -e "${RED}❌ Không tìm thấy script AI: $AI_SCRIPT${NC}"
    exit 1
fi

# Check if config exists
if [[ ! -f "$SCRIPT_DIR/config.json" ]]; then
    echo -e "${YELLOW}⚠️  Không tìm thấy config.json. Tạo file mặc định...${NC}"
    cat > "$SCRIPT_DIR/config.json" << 'EOF'
{
  "ai_provider": "gemini",
  "api_key": "",
  "model": "gemini-2.0-flash-exp",
  "endpoint": "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent",
  "max_tokens": 150,
  "temperature": 0.7,
  "enabled": true
}
EOF
    echo -e "${GREEN}✅ Đã tạo config.json${NC}"
fi

# Check API key
api_key=""
if command -v jq >/dev/null 2>&1; then
    api_key=$(jq -r '.api_key // empty' "$SCRIPT_DIR/config.json" 2>/dev/null)
else
    api_key=$(grep '"api_key"' "$SCRIPT_DIR/config.json" | sed 's/.*"api_key": *"\([^"]*\)".*/\1/' | head -1)
fi

if [[ -z "$api_key" ]]; then
    echo -e "${YELLOW}⚠️  API key chưa được cấu hình!${NC}"
    echo ""
    echo -e "${CYAN}📋 Để sử dụng AI features:${NC}"
    echo "1. Truy cập: https://makersuite.google.com/app/apikey"
    echo "2. Tạo API key mới"
    echo "3. Cập nhật 'api_key' trong file config.json"
    echo ""
    echo -e "${YELLOW}🔧 Demo sẽ chạy ở chế độ truyền thống (không AI)${NC}"
    USE_AI=false
else
    echo -e "${GREEN}✅ API key đã được cấu hình${NC}"
    USE_AI=true
fi

echo ""
echo -e "${CYAN}🎯 Chọn demo:${NC}"
echo "  [1] Demo với AI (nếu có API key)"
echo "  [2] Demo không AI (truyền thống)"
echo "  [3] Interactive mode"
echo "  [4] Thoát"
echo ""

read -p "Lựa chọn (1-4): " choice

case $choice in
    1)
        if [[ "$USE_AI" == true ]]; then
            echo -e "${GREEN}🤖 Demo với AI...${NC}"
            echo ""
            "$AI_SCRIPT" feat DEMO-001 "implement user dashboard with real-time analytics"
        else
            echo -e "${RED}❌ Không thể demo AI - thiếu API key${NC}"
        fi
        ;;
    2)
        echo -e "${YELLOW}⚡ Demo truyền thống...${NC}"
        echo ""
        "$AI_SCRIPT" --no-ai feat DEMO-002 "add user dashboard feature"
        ;;
    3)
        echo -e "${CYAN}📝 Interactive mode...${NC}"
        echo ""
        "$AI_SCRIPT"
        ;;
    4)
        echo -e "${YELLOW}👋 Tạm biệt!${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}❌ Lựa chọn không hợp lệ${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}🎉 Demo hoàn thành!${NC}"
echo ""
echo -e "${CYAN}📚 Để tìm hiểu thêm:${NC}"
echo "- Đọc README.md trong thư mục này"
echo "- Chạy: $AI_SCRIPT --help"
echo "- Hoặc: $AI_SCRIPT"