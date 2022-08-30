#!/usr/bin/env bash

## 版本号
Ver="Build 20220405-001-Alpha"

## 导入通用变量与函数
[[ -d "/ql/shell" ]] && dir_shell=/ql/shell
[[ -f "$dir_shell/share.sh" ]] && . $dir_shell/share.sh

## emoji 符号及分隔线
emoji_OK="✅"
emoji_NO="ߚ뢊emoji_UNKNOW="❓"
emoji_MSG="ߓᢊemoji_ON="߉ᢊemoji_OFF="߈⢊emoji_NONE="߈꯸emoji_DATE="ߓ梊emoji_SOS="߆袊emoji_CHART="ߓꢊemoji_OUTBOX="ߓ䢊emoji_INBOX="ߓ墊line="————————————————————————————————————————————"

## 获取 token
get_token() {
    local api_type=$1
    case $api_type in
        open)
            local api=$(
                    curl -s --connect-timeout 20 --retry 3 --noproxy "*" "${QL_URL_PORT}/open/auth/token?client_id=${QL_client_id}&client_secret=${QL_client_secret}"
                )

            if [[ $api =~ \"code\" ]]; then
                local code=$(echo $api | jq -r .code)
                [[ $api =~ \"msg\" ]] && local msg="($(echo $api | jq -r .msg))"
                if [[ $code == 200 ]]; then
                    token="$(echo $api | jq -r .data.token)"
                else
                    echo -e "# 获取token失败(${msg})"
                fi
            else
                echo -e "# 访问青龙失败，请检查地址、端口、OpenAPI的client_id、client_secret(${msg})"
            fi
            ;;
        closure)
            token=$(cat $file_auth_user | jq -r .token)
            ;;
    esac
}

## 版本号判断
function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
function version_le() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" == "$1"; }
function version_lt() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" != "$1"; }
function version_ge() { test "$(echo "$@" | tr " " "\n" | sort -rV | head -n 1)" == "$1"; }

# 读取青龙容器版本号
def_ql_version(){
    case $1 in
        open)
            curl -s --connect-timeout 20 --retry 3 --noproxy "*" "${QL_URL_PORT}/api/system" | jq -r .data.version
            ;;
        closure)
            curl -s --noproxy "*" "http://0.0.0.0:5600/api/system" | jq -r .data|jq -r .version
            ;;
    esac
}

# 定义 json 数据查询工具
def_envs_tool(){
    local token
    get_token $1
    if [[ $token ]]; then
        case $1 in
            open)
                curl -s --connect-timeout 20 --retry 3 --noproxy "*" "${QL_URL_PORT}/open/envs?searchValue=$2" -H "Authorization: Bearer $token" | jq .data
                ;;
            closure)
                curl -s --noproxy "*" "http://0.0.0.0:5600/api/envs?searchValue=$2" -H "Authorization: Bearer $token" | jq .data
                ;;
        esac
    fi
}

def_json_total(){
    def_envs_tool $1 $2 | jq .[].$3 | tr -d '[]," '
}

def_json_grep_match(){
    def_envs_tool $1 $2 | jq .[] | perl -pe '{s|([^}])\n|\1|g}' | grep "$4" | jq .$3 | tr -d '[]," '
}

def_json(){
    def_envs_tool $1 $2 | jq .[$3].$4 | perl -pe '{s|^"\|"$||g}' | grep -v "null"
}

def_json_match(){
    if [[ -f $1 ]]; then
        if [[ $3 && $(cat "$1" | grep "$3") ]]; then
            cat "$1" | perl -pe '{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}' | grep "$2" | jq -r .$3 | grep -v "null"
        else
            cat "$1" | perl -pe '{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}' | grep "$2" | grep -v "null"
        fi
    fi
}

def_json_value(){
    if [[ -f $1 ]]; then
        if [[ $(cat "$1" | grep "$2") ]]; then
            cat "$1" | perl -pe "{s|^\[\|\]$||g; s|\n||g; s|\},$|\}\n|g}" | grep "$3" | jq -r .$2 | grep -v "null"
        fi
    fi
}

def_sub(){
    local i j
    for i in $(def_json_total $1 $2 $3 | awk '/'$4'/{print NR}'); do
        j=$((i - 1));
        echo $j
    done
}

def_sub_value(){
    local line=$(($3 + 1))
    def_json_total $1 $2 $3 | awk 'NR=='$line''
}

# 时间戳转时间长度
UTC(){
    local i=$1
    local d h m s ms
    if [[ $i -gt 0 ]]; then
        d=$[i/86400000]
        h=$[(i-d*86400000)/3600000]
        m=$[(i-d*86400000-h*3600000)/60000]
        s=$[(i-d*86400000-h*3600000-m*60000)/1000]
        ms=$[i-d*86400000-h*3600000-m*60000-s*1000]
        [[ $d -gt 0 ]] && d="$d天" || d=""
        [[ $h -gt 0 ]] && h="$h小时" || h=""
        [[ $m -gt 0 ]] && m="$m分" || m=""
        [[ $s -gt 0 ]] && s="$s秒" || s=""
        [[ $ms -gt 0 ]] && ms="$ms毫秒" || ms=""
        if [[ $d || $h || $m || $s || $ms ]]; then
            echo "$d$h$m$s$ms"
        else
            echo "临期"
        fi
    fi
}

# 区间抽取随机数
random(){
    local min=$1
    local max=$2
    local RAND=`od -t uI -N 4 /dev/urandom | awk '{print $2}'`
    RAND=$[RAND%$[max-min+1]+min]
    echo $RAND
}

## 生成 json 值数组
gen_basic_value(){
    for i in $@; do
        eval $i='($(def_json_total $ck_api_type JD_COOKIE $i))'
    done
}

## 预备工作
pre_work() {
    # 青龙变量 key 识别
    #if version_lt $cur_version 2.11.0; then
    #   tmp_id="_id"
    #else
    #   tmp_id="id"
    #fi

    remote_id="id"
    [[ $(def_json_total $ck_api_type JD_COOKIE $remote_id) =~ null ]] && remote_id="_id"
    local_id="id"
    [[ $(def_json_total $wskey_api_type JD_WSCK $local_id) =~ null ]] && local_id="_id"
    remote_update_timestamp="updatedAt"
    [[ $(def_json_total $ck_api_type JD_COOKIE $remote_update_timestamp) =~ null ]] && remote_update_timestamp="timestamp"
    # 生成 JD_COOKIE id 面板更新时间 备注数组
    gen_basic_value value $remote_id remarks
    # 生成序号数组
    sn=($(def_json_total $ck_api_type JD_COOKIE value | awk '{print NR}'))
    # 生成pin值数组
    pin=($(def_json_total $ck_api_type JD_COOKIE value | perl -pe "{s|.*pt_pin=([^;\； ]+)(?=;?).*|\1|}"))
    # 生成非转码pin值数组
    pt_pin=($(urldecode "${pin[*]}"))

    NOTIFY_WxPusher_Condition
    Dump_Sign_UA_json
    wskey_array=($(def_json_total $wskey_api_type JD_WSCK value))

    LOCAL_DIR="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"	
    [[ $dir_scripts ]] && json_path="$dir_scripts" || json_path="$LOCAL_DIR"
    [[ $dir_log ]] && json_log_path="$dir_log" || json_log_path="$LOCAL_DIR"
    UA_cache_array=($(def_json_value "$json_path/CK_Sign_UA.json" UA))
    sign_cache_array=($(def_json_value "$json_path/CK_Sign_UA.json" sign))

    ori_valid_pin=($(def_json_match "$json_path/CK_WxPusherUid.json" '"status": 0' pin))
    [[ ! ${ori_valid_pin[@]} ]] && ori_valid_pin=($(def_json_grep_match $ck_api_type JD_COOKIE value '"status": 0'  | perl -pe "{s|.*pt_pin=([^;\； ]+)(?=;?).*|\1|}"))
    ori_invalid_pin=($(def_json_match "$json_path/CK_WxPusherUid.json" '"status": 1' pin))
    [[ ! ${ori_invalid_pin[@]} ]] && ori_invalid_pin=($(def_json_grep_match $ck_api_type JD_COOKIE value '"status": 1'  | perl -pe "{s|.*pt_pin=([^;\； ]+)(?=;?).*|\1|}"))

    [[ -n "$(echo $NOTIFY_VALID_DAY | sed -n "/^[0-9]\+$/p")" ]] && notify_valid_period="$((NOTIFY_VALID_DAY * 86400000))" || notify_valid_period=""
    [[ -n "$(echo $WSKEY_UPDATE_VALIDITY_HOUR | sed -n "/^[0-9]\+$/p")" ]] && wskey_update_validity_period="$((WSKEY_UPDATE_VALIDITY_HOUR * 3600000))" || wskey_update_validity_period=""

    #content_top=$(echo "$ExNotify_Top_Content" | awk '{print $0"\n\n"}')
    #content_bot=$(echo "$ExNotify_Bot_Content" | awk '{print "\n\n"$0}')
    content_top="$ExNotify_Top_Content\n\n"
    content_bot="\n\n$ExNotify_Bot_Content"

    [[ $WSKEY_AUTO_ENABLE ]] && process_notify_type_0="生效" || process_notify_type_0="重启"
    [[ $WSKEY_AUTO_DISABLE ]] && process_notify_type_1="失效" || process_notify_type_1="禁用"
}

UA_array=(
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017311801,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YtVtZJCzCJPrDtU0ZJS0DK==","od":"YwDrZQCyYJSmCtUnDwG5EK==","ov":"CzO=","ud":"YtVtZJCzCJPrDtU0ZJS0DK=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017332518,"ridx":-1,"cipher":{"sv":"CJS=","ad":"EWTrCJu0ZtTwEWZrEWYmYG==","od":"EJY4YtdsEQDvYJumYzO4ZG==","ov":"CzO=","ud":"EWTrCJu0ZtTwEWZrEWYmYG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017353909,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YtuyZwHrZtG1EWC4CwDrCq==","od":"EJOmYzY4DQPuDJTsDwY3Dq==","ov":"CzO=","ud":"YtuyZwHrZtG1EWC4CwDrCq=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017371843,"ridx":-1,"cipher":{"sv":"CJS=","ad":"EJK5ZJDrZtTuCJTtZWSnCm==","od":"YWG5ZNUyDtvrENc3DWDsZG==","ov":"CzO=","ud":"EJK5ZJDrZtTuCJTtZWSnCm=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017391063,"ridx":-1,"cipher":{"sv":"CJS=","ad":"EWU3CQCzCtdsCWTtYWYnDK==","od":"EJc4YJPuZWC0ZNK1YtumYq==","ov":"CzO=","ud":"EWU3CQCzCtdsCWTtYWYnDK=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017404692,"ridx":-1,"cipher":{"sv":"CJS=","ad":"ENK2CQGmDNqzYzczZtcyDK==","od":"YtY2DJUyDtG2YwU2EQY3YG==","ov":"CzO=","ud":"ENK2CQGmDNqzYzczZtcyDK=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017422249,"ridx":-1,"cipher":{"sv":"CJS=","ad":"EWO0YwHwEJU2ZtVtZNC5Dm==","od":"EQTwDQS1Yzq2ZJY3C2G1Ym==","ov":"CzO=","ud":"EWO0YwHwEJU2ZtVtZNC5Dm=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017438445,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YJY4DzumZtqmZtCzY2Y1ZK==","od":"ENK5ENKzYJG1ZwS0DtLtDG==","ov":"CzO=","ud":"YJY4DzumZtqmZtCzY2Y1ZK=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017462999,"ridx":-1,"cipher":{"sv":"CJS=","ad":"Ytu5DzvsCtOmEQC4YwDuCG==","od":"Ytc4DQDtDJvvCWSzDtTvYG==","ov":"CzO=","ud":"Ytu5DzvsCtOmEQC4YwDuCG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017508723,"ridx":-1,"cipher":{"sv":"CJS=","ad":"ENu2Y2ZrDWTwYwO5DtTrDG==","od":"YJcyCzO0ENPvDwY3EJC2Dm==","ov":"CzO=","ud":"ENu2Y2ZrDWTwYwO5DtTrDG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017524153,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YtVtCtLsZNK5C2U5CQY3Cm==","od":"YJK2ZtrsZWUyCNc2ZWG1Yq==","ov":"CzO=","ud":"YtVtCtLsZNK5C2U5CQY3Cm=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017540904,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YwY0DwO2YWVuDzPuZJczYm==","od":"YJDuZWVwCzvwYtq3YtDvCm==","ov":"CzO=","ud":"YwY0DwO2YWVuDzPuZJczYm=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017554598,"ridx":-1,"cipher":{"sv":"CJS=","ad":"EJq4ZJDsCzVrCzS4CQOmDm==","od":"EJTsY2GmEWHtCJPuDzY3DG==","ov":"CzO=","ud":"EJq4ZJDsCzVrCzS4CQOmDm=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017568630,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YtvwCtrtDwY2YJG3ENumYG==","od":"EJrvEQTsENKzCNOmY2Y4ZG==","ov":"CzO=","ud":"YtvwCtrtDwY2YJG3ENumYG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017582006,"ridx":-1,"cipher":{"sv":"CJS=","ad":"ENC5YzPrYtduYWS1CJvuYG==","od":"YWDuCNLvDJdvYWVsY2HwZq==","ov":"CzO=","ud":"ENC5YzPrYtduYWS1CJvuYG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017595384,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YtZtC2TrDQU4CzY5DQS2DG==","od":"YtK2CQZvDJq1C2S3ZNrrEG==","ov":"CzO=","ud":"YtZtC2TrDQU4CzY5DQS2DG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017608189,"ridx":-1,"cipher":{"sv":"CJS=","ad":"ENrsYzDrDtHwYzLrYtTwZG==","od":"YJOmZQG3CwVsENcmEJTwCK==","ov":"CzO=","ud":"ENrsYzDrDtHwYzLrYtTwZG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017621253,"ridx":-1,"cipher":{"sv":"CJS=","ad":"EJdvDJc1ZNUyY2PtZQHwCG==","od":"YtC3DQO3Y2OyENc5EQU1Dq==","ov":"CzO=","ud":"EJdvDJc1ZNUyY2PtZQHwCG=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017633805,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YwG1CwOzDQCmDWZrDWDrCq==","od":"YJKnENY0CQGnDQPtCzC5DK==","ov":"CzO=","ud":"YwG1CwOzDQCmDWZrDWDrCq=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
    'jdapp;android;10.3.5;;;appBuild/92468;ef/1;ep/{"hdid":"JM9F1ywUPwflvMIpYPok0tt5k9kW4ArJEU3lfLhxBqw=","ts":1647017647337,"ridx":-1,"cipher":{"sv":"CJS=","ad":"YJZwENKnDNDrCtu3ENUyDq==","od":"YtY4DtdtYtumCzDrCtU4Zq==","ov":"CzO=","ud":"YJZwENKnDNDrCtu3ENUyDq=="},"ciphertype":5,"version":"1.2.0","appname":"com.jingdong.app.mall"};Mozilla/5.0'
)

# 生成一对一通知的时间条件
NOTIFY_WxPusher_Condition(){
    local current_H hour
    current_H=`date +%H`
    local NOTIFY_WxPusher_TIME=$(eval echo $(echo $NOTIFY_WxPusher_TIME | perl -pe "{s|~\|-|_|g; s|\W+\|[A-Za-z]+| |g; s|(\d+)_(\d+)|{\1..\2}|g;}"))
    NOTIFY_WxPusher_Schedule=""
    for hour in $NOTIFY_WxPusher_TIME; do
        [[ $hour = $current_H ]] && NOTIFY_WxPusher_Schedule="on" && break
    done
}

#青龙启用/禁用环境变量API
ql_process_env_api() {
    local token
    local currentTimeStamp=$(date +%s)
    local api_type=$1
    local name=$2
    local id=$3
    local status_code=$4
    local process_chinese=$5
    local emoji
    [[ $status_code = 0 ]] && process=enable && emoji=${emoji_ON}
    [[ $status_code = 1 ]] && process=disable && emoji=${emoji_OFF}

    case $api_type in
        open)
            local url="${QL_URL_PORT}/open/envs/$process"
            ;;
        closure)
            local url="http://0.0.0.0:5600/api/envs/$process"
            ;;
    esac

    get_token $api_type
    if [[ $token ]]; then
        local api=$(
            curl -s --connect-timeout 20 --retry 3 --noproxy "*" "$url?t=$currentTimeStamp" \
                -X 'PUT' \
                -H "Accept: application/json" \
                -H "Authorization: Bearer $token" \
                -H "Content-Type: application/json;charset=UTF-8" \
                --data-raw "[\"$id\"]"
        )

        code=$(echo $api | jq -r .code)
        message=$(echo $api | jq -r .message)
        if [[ $code == 200 ]]; then
            [[ $notify = on ]] && echo -n "${emoji} $name$process_chinese"
        else
            [[ $notify = on ]] && echo -n "${emoji} $name$process_chinese失败(${message})"
        fi
    fi
}

#青龙添加环境变量API
ql_add_env_api() {
    local token
    local currentTimeStamp=$(date +%s)
    local api_type=$1
    local name=$2
    local value=$3
    local remarks=$4

    case $api_type in
        open)
            local url="${QL_URL_PORT}/open/envs"
            ;;
        closure)
            local url="http://0.0.0.0:5600/api/envs"
            ;;
    esac

    get_token $api_type
    if [[ $token ]]; then
        if [[ $remarks ]]; then
            local api=$(
                curl -s --connect-timeout 20 --retry 3 --noproxy "*" "$url?t=$currentTimeStamp" \
                    -X 'POST' \
                    -H "Accept: application/json" \
                    -H "Authorization: Bearer $token" \
                    -H "Content-Type: application/json;charset=UTF-8" \
                    --data-raw "[{\"name\":\"$name\",\"value\":\"$value\",\"remarks\":\"$remarks\"}]"
            )
        else
            local api=$(
                curl -s --connect-timeout 20 --retry 3 --noproxy "*" "$url?t=$currentTimeStamp" \
                    -X 'POST' \
                    -H "Accept: application/json" \
                    -H "Authorization: Bearer $token" \
                    -H "Content-Type: application/json;charset=UTF-8" \
                    --data-raw "[{\"name\":\"$name\",\"value\":\"$value\"}]"
            )
        fi
    
        code=$(echo $api | jq -r .code)
        message=$(echo $api | jq -r .message)
        if [[ $code == 200 ]]; then
            [[ $notify = on ]] && echo -n "${emoji_OK} $name -> 添加成功"
        else
            [[ $notify = on ]] && echo -n "${emoji_NO} $name -> 添加失败(${message})"
        fi
    fi
}

#青龙更新环境变量API
ql_update_env_api() {
    local token id_type
    local currentTimeStamp=$(date +%s)
    local api_type=$1
    local name=$2
    local value=$3
    local id=$4
    local remarks=$5
    local message=$6

    case $api_type in
        open)
            id_type=$remote_id
            local url="${QL_URL_PORT}/open/envs"
            ;;
        closure)
            id_type=$local_id
            local url="http://0.0.0.0:5600/api/envs"
            ;;
    esac

    get_token $api_type
    if [[ $token ]]; then
        if [[ $remarks ]]; then
            local api=$(
                curl -s --connect-timeout 20 --retry 3 --noproxy "*" "$url?t=$currentTimeStamp" \
                    -X 'PUT' \
                    -H "Accept: application/json" \
                    -H "Authorization: Bearer $token" \
                    -H "Content-Type: application/json;charset=UTF-8" \
                    --data-raw "{\"name\":\"$name\",\"value\":\"$value\",\"$id_type\":\"$id\",\"remarks\":\"$remarks\"}"
            )
        else
            local api=$(
                curl -s --connect-timeout 20 --retry 3 --noproxy "*" "$url?t=$currentTimeStamp" \
                    -X 'PUT' \
                    -H "Accept: application/json" \
                    -H "Authorization: Bearer $token" \
                    -H "Content-Type: application/json;charset=UTF-8" \
                    --data-raw "{\"name\":\"$name\",\"value\":\"$value\",\"$id_type\":\"$id\"}"
            )
        fi
    
        code=$(echo $api | jq -r .code)
        if [[ $code == 200 ]]; then
            [[ $notify = on ]] && echo -n "${emoji_OK} $name -> 更新成功(${message})"
        else
            message=$(echo $api | jq -r .message)
            [[ $notify = on ]] && echo -n "${emoji_NO} $name -> 更新失败(${message})"
        fi
    fi
}

# 查询 WxPusher 应用用户 APT
check_WxPusher_User(){
        local appToken=$1
        local page=$2
        local pageSize=$3
        local isBlock$4
        local host="http://wxpusher.zjiecode.com/api/fun/wxuser/v2"
        local url="http://wxpusher.zjiecode.com/api/fun/wxuser/v2?appToken=${appToken}&page=${page}&pageSize=${pageSize}"
        local api=$(
            curl -s -k --connect-timeout 20 --retry 3 --noproxy "*" "${url}"
        )
}

## WxPusher 通知 API
WxPusher_notify_api() {
    local appToken=$1
    local uids=$2
    local title=$3
    local summary=$4
    local content=$5
    local frontcontent=$6
    local summary=$(echo -e "$title\n\n$summary" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    [[ ${#summary} -ge 100 ]] && local summary="${summary:0:88} ……"
    local content=$(echo -e "$title\n\n$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="http://wxpusher.zjiecode.com/api/send/message"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"appToken\":\"${appToken}\",\"content\":\"${content}\",\"summary\":\"${summary}\",\"contentType\":\"2\",\"uids\":[$uids]}"
    )
    code=$(echo $api | jq -r .code)
    msg=$(echo $api | jq -r .msg)
    if [[ $code == 1000 ]]; then
        echo -e "${emoji_OUTBOX}$frontcontent WxPusher 消息发送成功(${uids})"
    else
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "${emoji_INBOX}$frontcontent WxPusher 消息发送处理失败(${msg})"
    fi
}

## 企业微信机器人通知 API
QYWX_Bot_notify_api() {
    local bot_key=$1
    local title=$2
    local content=$3
    local frontcontent=$4
    local content="$title\n\n$content"
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g}')
    local url="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=${bot_key}"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"msgtype\":\"text\",\"text\":{\"content\":\"$content\"}}"
    )
    code=$(echo $api | jq -r .errcode)
    msg=$(echo $api | jq -r .errmsg)
    if [[ $code == 0 ]]; then
        echo -e "${emoji_OUTBOX}$frontcontent 企业微信机器人消息发送成功"
    else
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "${emoji_INBOX}$frontcontent 企业微信机器人消息发送处理失败(${msg})"
    fi
}

## 企业微信应用通知 API
QYWX_notify_api() {
    local corpid="$(echo $1 | awk -F ',' '{print $1}')"
    local corpsecret="$(echo $1 | awk -F ',' '{print $2}')"
    local userId="$(echo $1 | awk -F ',' '{print $3}')"
    local agentid="$(echo $1 | awk -F ',' '{print $4}')"
    local thumb_media_id="$(echo $1 | awk -F ',' '{print $5}')"
    local author=$2
    local title=$3
    local digest=$4
    local content=$5
    local frontcontent=$6
    local ACCESS_TOKEN
    local digest=$(echo -e "$digest" | perl -pe '{s|(\")|'\\'\\1|g}')
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=${corpid}&corpsecret=${corpsecret}"

    local api=$(
        curl -s --noproxy "*" "$url"
    )

    local code=$(echo $api | jq -r .errcode)
    local msg=$(echo $api | jq -r .errmsg)
    if [[ $code == 0 ]]; then
        ACCESS_TOKEN=$(echo $api | jq -r .access_token)
        local url="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=${ACCESS_TOKEN}"

        if [[ $thumb_media_id ]]; then
            local api=$(
                curl -s --noproxy "*" "$url" \
                    -X 'POST' \
                    -H "Content-Type: application/json" \
                    --data-raw "{\"touser\":\"$userId\",\"msgtype\":\"mpnews\",\"agentid\":\"$agentid\",\"mpnews\":{\"articles\":[{\"title\":\"$title\",\"thumb_media_id\":\"$thumb_media_id\",\"author\":\"$author\",\"content\":\"$content\",\"digest\":\"$digest\"}]}}"
            )
        else
            local api=$(
                curl -s --noproxy "*" "$url" \
                    -X 'POST' \
                    -H "Content-Type: application/json" \
                    --data-raw "{\"touser\":\"$userId\",\"msgtype\":\"mpnews\",\"agentid\":\"$agentid\",\"mpnews\":{\"articles\":[{\"title\":\"$title\",\"thumb_media_id\":\"$thumb_media_id\",\"author\":\"$author\",\"content\":\"$content\",\"digest\":\"$digest\"}]}}"
            )
        fi

        code=$(echo $api | jq -r .errcode)
        msg=$(echo $api | jq -r .errmsg)
        if [[ $code == 0 ]]; then
            echo -e "${emoji_OUTBOX}$frontcontent 企业微信应用消息发送成功"
        else
            [[ ! $msg ]] && msg="访问 API 超时"
            echo -e "${emoji_INBOX}$frontcontent 企业微信应用消息发送处理失败(${msg})"
        fi
    fi
}

## pushplus 通知 API
pushplus_notify_api() {
    local token=$1
    local topic=$2
    local title=$3
    local content=$4
    local frontcontent=$5
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="http://www.pushplus.plus/send"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\"}"
    )

    code=$(echo $api | jq -r .code)
    msg=$(echo $api | jq -r .msg)
    if [[ $code == 200 ]]; then
        echo -e "${emoji_OUTBOX}$frontcontent pushplus 消息发送成功"
    else
        if [[ $code == 500 ]]; then
            msg="服务器宕机"
        fi
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "${emoji_INBOX}$frontcontent pushplus 消息发送处理失败(${msg})"
    fi
}

## hxtrip pushplus 通知 API
hxtrip_pushplus_notify_api() {
    local token=$1
    local topic=$2
    local title=$3
    local content=$4
    local frontcontent=$5
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|<br>|g}')
    local url="http://pushplus.hxtrip.com/send"

    local api=$(
        curl -s --noproxy "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"token\":\"$token\",\"title\":\"$title\",\"content\":\"$content\"}"
    )
    code=$(echo $api | perl -pe '{s|.*<code>([\d]+)</code>.*|\1|g}')
    msg=$(echo $api | perl -pe '{s|.*<msg>([\S]+)</msg>.*|\1|g}')
    if [[ $code == 200 ]]; then
        echo -e "${emoji_OUTBOX}$frontcontent hxtrip pushplus 消息发送成功"
    else
        if [[ $code == 500 ]]; then
            msg="服务器宕机"
        fi
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "${emoji_INBOX}$frontcontent hxtrip pushplus 消息发送处理失败(${msg})"
    fi
}

## Telegram 通知 API
Telegram_notify_api() {
    local token=$1
    local chat_id=$2
    local title=$3
    local content=$4
    local frontcontent=$5
    local content=$(echo -e "$content" | perl -pe '{s|(\")|'\\'\\1|g; s|\n|\\n|g}')
    [[ ! $TG_API_HOST ]] && TG_API_HOST="api.telegram.org"
    local url="https://${TG_API_HOST}/bot${token}/sendMessage"

    if [[ $TG_PROXY_HOST && $TG_PROXY_PORT && $TG_PROXY_AUTH ]]; then
        local https_proxy=http://$TG_PROXY_AUTH@$TG_PROXY_HOST:$TG_PROXY_PORT/
    elif [[ $TG_PROXY_HOST && $TG_PROXY_PORT ]]; then
        local https_proxy=http://$TG_PROXY_HOST:$TG_PROXY_PORT/
    else
        local https_proxy=""
    fi

    local api=$(
        curl -s --connect-timeout 20 --retry 3 "*" "$url" \
            -X 'POST' \
            -H "Content-Type: application/json" \
            --data-raw "{\"chat_id\":\"${chat_id}\",\"text\":\"${title}\n\n${content}\",disable_web_page_preview:true}"
    )

    code=$(echo $api | jq -r .ok)
    msg=$(echo $api | jq -r .description)
    if [[ $code == true ]]; then
        echo -e "${emoji_OUTBOX}$frontcontent Telegram 消息发送成功"
    else
        [[ ! $msg ]] && msg="访问 API 超时"
        echo -e "${emoji_INBOX}$frontcontent Telegram 消息发送处理失败(${msg})"
    fi
}

# JSON 字符串特殊符号处理
spc_sym_tr(){
    #echo $1 | perl -pe '{s|(\"\|'\''\|\[\|\]\|{\|}\|\\\|\/\|`)|'\\'\\1|g}'
    echo $1 | perl -pe '{s|(\")|'\\'\\1|g}'
}

# 字符串 urlencode 加密
urlencode() {
    local LANG=C
    for ((i=0;i<${#1};i++)); do
        if [[ ${1:$i:1} =~ ^[a-zA-Z0-9\.\~\_\-]$ ]]; then
            printf "${1:$i:1}"
        else
            printf '%%%02X' "'${1:$i:1}"
        fi
    done
}

# 字符串 urldecode 解密
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

# 数组的汇总处理
print_array(){
    local array=$1
    echo ${array[@]}|perl -pe '{s|\\n[\s]+|\\n|g}'
}

## 获取用户信息 API 1
Get_CK_Status_1(){
    local url="https://me-api.jd.com/user_new/info/GetJDUserInfoUnion"
    local UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36 Edg/96.0.1054.62"

    local api=$(
        curl -s --connect-timeout 20 --retry 3 --noproxy "*" "$url" \
            -H "Host: me-api.jd.com" \
            -H "Accept: */*" \
            -H "Connection: keep-alive" \
            -H "Cookie: $cookie" \
            -H "User-Agent: $UA" \
            -H "Accept-Language: zh-cn" \
            -H "Referer: https://home.m.jd.com/myJd/newhome.action?sceneval=2&ufc=&" \
            -H "Accept-Encoding:  deflate, br"
    )

    if [[ $api =~ \"retcode\" ]]; then
        local retcode=$(echo $api | jq -r .retcode)
        [[ $api =~ \"msg\" ]] && local msg="($(echo $api | jq -r .msg))"
        if [[ $retcode == 0 ]]; then
            ckck_code="0" && ckck_msg="Cookie 状态正常" && nickname="$(echo $api | jq -r .data | jq -r .userInfo | jq -r .baseInfo | jq -r .nickname)"
        elif [[ $retcode == 1000 ]]; then
            ckck_code="$retcode" && ckck_msg="${msg}"
        elif [[ $retcode == 1001 ]]; then
            ckck_code="1" && ckck_msg="Cookie 状态失效(${msg})"
        else
            ckck_code="$retcode" && ckck_msg="未知错误(${msg})"
        fi
    else
        ckck_code="2" && ckck_msg="API 访问失败"
    fi
}

## 获取用户信息 API 2
Get_CK_Status_2(){
    local currentTimeStamp=$(date +%s)
    local url="https://wxapp.m.jd.com/kwxhome/myJd/home.json?&useGuideModule=0&bizId=&brandId=&fromType=wxapp&timestamp=$currentTimeStamp"
    local UA="Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 MicroMessenger/8.0.10(0x18000a2a) NetType/WIFI Language/zh_CN"

    local api=$(
        curl -s --connect-timeout 20 --retry 3 --noproxy "*" "$url" \
            -H "Content-Type: application/x-www-form-urlencoded" \
            -H "Host: wxapp.m.jd.com" \
            -H "Connection: keep-alive" \
            -H "Cookie: $cookie" \
            -H "User-Agent: $UA" \
            -H "Referer: https://servicewechat.com/wxa5bf5ee667d91626/161/page-frame.html" \
            -H "Accept-Encoding:  compress,deflate, br"
    )

    if [[ $api ]]; then
        if [[ $api =~ \"petName\" ]]; then
            ckck_code="0" && ckck_msg="Cookie 状态正常" && nickname="$(echo $api | jq -r .user | jq -r .petName)"
        elif [[ $api =~ \"code\" ]]; then
            local code=$(echo $api | jq -r .code)
            [[ $api =~ \"msg\" ]] && local msg="($(echo $api | jq -r .msg))"
            if [[ $code == 999 ]]; then
                ckck_code="1" && ckck_msg="Cookie 状态失效${msg}"
            else
                ckck_code="3" && ckck_msg="未知错误${api}"
            fi
        else
            ckck_code="3" && ckck_msg="未知错误${api}"
        fi
    else
        ckck_code="2" && ckck_msg="API 访问失败"
    fi
}

## 获取用户昵称 API
Get_NickName() {
    local cookie=$1
    Get_CK_Status_1
    [[ $ckck_code = 2 ]] && Get_CK_Status_2
}

# 名称处理
Get_Full_Name(){
    local i=$1
    local j=${pin[i]}
    local remarks_ori_id tmp_NickName_1 tmp_NickName_2 UserName nickname tmp_remarks_id_1 tmp_remarks_id_2 tmp_remarks_id_3 wskey_pin_sub
    # 获取原始备注
    remarks_ori[$j]="${remarks[i]}"
    [[ ${remarks_ori[$j]} = null ]] && remarks_ori[$j]=""

    # JD_COOKIE 相关值
    value[i]="$(echo ${value[i]} | grep -Eo 'pt_key=[^;\； ]+' | head -1);pt_pin=$j;"

    # wskey 相关值
    wskey_value[$j]="$(def_json_grep_match $wskey_api_type JD_WSCK value "pin=$j;" | head -1)"
    [[ ${wskey_value[$j]} =~ "wskey=" ]] && wskey_value[$j]="pin=$j;$(echo ${wskey_value[$j]} | grep -Eo 'wskey=[^;\； ]+' | head -1);"
    wskey_id[$j]="$(def_json_grep_match $wskey_api_type JD_WSCK $local_id "pin=$j;" | head -1)"
    wskey_remarks[$j]="$(def_json_grep_match $wskey_api_type JD_WSCK remarks "pin=$j;" | grep -v "null" | head -1)"

    # 昵称及用户名处理
    Get_NickName "${value[i]}"
    tmp_NickName_1=${nickname}
    tmp_NickName_2="$(def_json_value "$json_path/CK_WxPusherUid.json" NickName "pin=$j;")"
    if [[ ${tmp_NickName_1} ]]; then
        NickName[$j]="${tmp_NickName_1}"
    elif [[ ${tmp_NickName_2} ]]; then
        NickName[$j]="${tmp_NickName_2}"
    else
        NickName[$j]=""
    fi
    [[ ! ${NickName[$j]} ]] && UserName=${pt_pin[i]} || UserName=${NickName[$j]}

    # 备注名处理
    [[ ${remarks_ori[$j]} ]] && tmp_remarks_id_1="$(echo ${remarks_ori[$j]} | perl -pe '{s|(^((?!@@(([\d]{13}\|UID_[\w]{28}))).)*).*|\1|}')"
    [[ ${wskey_remarks[$j]} ]] && tmp_remarks_id_2="${wskey_remarks[$j]}"
    tmp_remarks_id_3="$(def_json_value "$json_path/CK_WxPusherUid.json" remarks "pin=$j;")"
    if [[ $tmp_remarks_id_1 ]]; then
        remarks_id[$j]="$tmp_remarks_id_1"
        remarks_name[$j]="(${remarks_id[$j]})"
    elif [[ $tmp_remarks_id_2 ]]; then
        remarks_id[$j]="$tmp_remarks_id_2"
        remarks_name[$j]="(${remarks_id[$j]})"
    elif [[ $tmp_remarks_id_3 ]]; then
        remarks_id[$j]="$tmp_remarks_id_3"
        remarks_name[$j]="(${remarks_id[$j]})"
    else
        remarks_id[$j]=""
        remarks_name[$j]="(未备注)"
    fi
    full_name[$j]="【${sn[i]}】${UserName}${remarks_name[$j]}"

    # WxPusherUid 相关值
    tmp_Uid_1[$j]="$(echo ${remarks_ori[$j]} | grep -Eo 'UID_\w{28}' | head -1)"
    tmp_Uid_2[$j]="$(def_json_value "$json_path/CK_WxPusherUid.json" Uid "pin=$j;" | grep -Eo 'UID_\w{28}' | head -1)"
    if [[ ${tmp_Uid_1[$j]} ]]; then
        Uid[$j]="${tmp_Uid_1[$j]}"
    elif [[ ${tmp_Uid_2[$j]} ]]; then
        Uid[$j]="${tmp_Uid_2[$j]}"
    else
        Uid[$j]=""
    fi
}

# 批量检查 Cookie 有效性
verify_ck(){
    # JD_COOKIE 有效性检查
    check_ck(){
        local i=$1
        local notify=$2
        local j=${pin[i]}
        local jd_cookie emoji timestamp_ms tmp_up_timestamp_1 tmp_up_timestamp_2 timestamp_d_value
        status_ori[$j]="$(def_json $ck_api_type JD_COOKIE $i status)"
        status_json[$j]="$(def_json_value "$json_path/CK_WxPusherUid.json" status "pin=$j;")"
        status_last[$j]="${status_json[$j]}"
        value_json[$j]="$(def_json_value "$json_path/CK_WxPusherUid.json" JD_COOKIE "pin=$j;")"
        [[ ! ${status_last[$j]} ]] && status_last[$j]=${status_ori[$j]}

        ck_status[$j]="$ckck_code"
        if [[ $ckck_code = 0 ]]; then
            ck_valid[i]="${full_name[$j]}\n"
            if [[ ${status_last[$j]} = 1 ]]; then
                ck_status_chinese="生效"
                ck_process_chinese="重启"
            else
                ck_status_chinese="正常"
                ck_process_chinese="启用"
            fi
            emoji=$emoji_OK
        elif [[ $ckck_code = 1 ]]; then
            ck_invalid[i]="${full_name[$j]}\n"
            ck_status_chinese="失效"
            ck_process_chinese="禁用"
            emoji=$emoji_NO
        else
            ck_unknown_state[i]="${full_name[$j]}\n"
            ck_status_chinese="因$ckck_msg跳过检测"
            emoji=$emoji_MSG
        fi
        echo -n "${emoji} JD_COOKIE$ck_status_chinese"

        if [[ ${ck_status[$j]} = 0 ]]; then
            tmp_up_timestamp_1="$(echo $(def_json $ck_api_type JD_COOKIE $i remarks) | grep -Eo '@@\d{13}' | grep -Eo '\d{13}' | head -1)"
            tmp_up_timestamp_2="$[$(date -d "$(def_json $ck_api_type JD_COOKIE $i $remote_update_timestamp)" +%s%N)/1000000]"
            timestamp_d_value=$[tmp_up_timestamp_1-tmp_up_timestamp_2]
            if [[ ${status_json[$j]} = 1 ]] || [[ ${value_json[$j]} && ${value[i]} != ${value_json[$j]} && ${timestamp_d_value#-} -ge 60000 ]]; then
                timestamp_ms=$tmp_up_timestamp_2
                if [[ ${Uid[$j]} ]]; then
                    remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms@@${Uid[$j]}"
                else
                    remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms"
                fi
                echo -e ""
                ql_update_env_api $ck_api_type JD_COOKIE "${value[i]}" $(eval echo \${$remote_id[i]}) "${remarks_new[$j]}" "更新备注时间戳"
            fi
        fi
    }

    wskey_analysis(){
        local i=$1
        local j=${pin[i]}
        local notify=$2
        local timestamp_ms emoji
        wskey_status_ori[$j]="$(def_json_grep_match $wskey_api_type JD_WSCK status "pin=$j;" | head -1)"
        wskey_status_json[$j]="$(def_json_value "$json_path/CK_WxPusherUid.json" wskey_status "pin=$j;")"
        wskey_status_last[$j]="${wskey_status_json[$j]}"
        [[ ! ${wskey_status_last[$j]} ]] && wskey_status_last[$j]=${wskey_status_ori[$j]}
        if [[ $wsck_to_ck_code = 0 ]]; then
            wskey_status[$j]="0"
            if [[ ${wskey_status_last[$j]} = 1 ]]; then
                wskey_status_chinese="生效"
                wskey_process_chinese="重启"
            else
                wskey_status_chinese="正常"
                wskey_process_chinese="启用"
            fi
            emoji=$emoji_OK
            if [[ ${ck_status[$j]} = 1 ]] || [[ ! ${ck_status[$j]} ]]; then
                value[i]=${jd_cookie}
                if [[ ${ck_status[$j]} = 1 ]]; then
                    ck_status[$j]="0"
                    unset ck_invalid[i]
                    ck_valid[i]="${full_name[$j]}\n"
                    if [[ ${status_last[$j]} = 1 ]]; then
                        ck_status_chinese="生效"
                        ck_process_chinese="重启"
                    else
                        ck_status_chinese="正常"
                        ck_process_chinese="启用"
                    fi
                    [[ $notify = on ]] && echo -e "" && echo -n "${emoji} $wsck_to_ck_msg"
                    timestamp_ms="$[$(date +%s%N)/1000000]"
                    if [[ ${Uid[$j]} ]]; then
                        remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms@@${Uid[$j]}"
                    else
                        remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms"
                    fi
                    echo -e ""
                    ql_update_env_api $ck_api_type JD_COOKIE "${value[i]}" $(eval echo \${$remote_id[i]}) "${remarks_new[$j]}" "更新环境变量值"
                elif [[ ! ${ck_status[$j]} ]]; then
                    ck_status[$j]="0"
                    Get_Full_Name $i
                    ck_valid[i]="${full_name[$j]}\n"
                    ck_added[i]="${full_name[$j]}\n"
                    ck_status_chinese="生效"
                    ck_process_chinese="添加"
                    timestamp_ms="$[$(date +%s%N)/1000000]"
                    if [[ ${Uid[$j]} ]]; then
                        remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms@@${Uid[$j]}"
                    else
                        remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms"
                    fi
                    echo -e "ߧᢀ�쾤{full_name[$j]}"
                    echo -e "${emoji} $wsck_to_ck_msg"
                    ql_add_env_api $ck_api_type JD_COOKIE "${value[i]}" "${remarks_new[$j]}"
                fi
            fi
        else
            if [[ $wsck_to_ck_code = 4 ]]; then
                wskey_status[$j]="1"
                wskey_status_chinese="失效"
                wskey_process_chinese="禁用"
                wskey_invalid[i]="${full_name[$j]}\n"
                emoji=$emoji_NO
            else
                wskey_status[$j]="2"
                wskey_status_chinese="因$wsck_to_ck_msg跳过检测"
                emoji=$emoji_MSG
            fi
            [[ ! ${ck_status[$j]} ]] && echo -n "ߧᢀ�쾤{full_name[$j]}"
            [[ $notify = on ]] && [[ ${ck_status[$j]} = 1 ]] || [[ ! ${ck_status[$j]} ]] && echo -e "" && echo -n "${emoji} 因$wsck_to_ck_msg，转换JD_COOKIE失败"
        fi
        [[ $notify = on ]] && echo -e "" && echo -n "${emoji} JD_WSCK(wskey)$wskey_status_chinese"
        if [[ ${wskey_status[$j]} = 0 || ${wskey_status[$j]} = 1 ]]; then
            if [[ ${wskey_status[$j]} != ${wskey_status_ori[$j]} && ${wskey_status_ori[$j]} ]] || [[ ${wskey_status[$j]} = 1 && ! ${wskey_status_ori[$j]} ]]; then
                echo -e ""
                ql_process_env_api $wskey_api_type JD_WSCK ${wskey_id[$j]} ${wskey_status[$j]} $wskey_process_chinese
            fi
        fi
    }

    # JD_WSCK(wskey) 录入情况检查
    check_wskey(){
        local i=$1
        local j=${pin[i]}
        local notify=$2

        if [[ ! ${wskey_value[$j]} ]]; then
            wskey_status[$j]="3"
            if [[ $NOTIFY_WSKEY_NO_EXIST = 1 || $NOTIFY_WSKEY_NO_EXIST = 2 ]]; then
                ck_none_wskey[i]="${full_name[$j]}\n"
                [[ $notify = on ]] && echo -e "" && echo -n "${emoji_NONE} 未录入JD_WSCK(wskey)"
            fi
        else
            wsck_to_ck ${wskey_value[$j]}
            wskey_analysis $i on
        fi

        if [[ ${ck_status[$j]} != ${status_ori[$j]} ]]; then
            if [[ ${ck_status[$j]} = 0 && ! $WSKEY_AUTO_ENABLE ]] || [[ ${ck_status[$j]} = 1 && ! $WSKEY_AUTO_DISABLE ]]; then
                echo -e ""
                ql_process_env_api $ck_api_type JD_COOKIE "$(eval echo \${$remote_id[i]})" "${ck_status[$j]}" "$ck_process_chinese"
                echo -e ""
            fi
        else
            echo -e ""
        fi
    }

    # 账号有效期检查
    check_validity(){
        local i=$1
        local notify=$2
        local j=${pin[i]}
        local tmp_up_timestamp_1 tmp_up_timestamp_2 total_validity_period timestamp_ms remain_validity_period last_validity_period valid_time
        if [[ ${ck_status[$j]} = 0 ]]; then
            [[ ${value[i]} == *app_open* ]] && total_validity_period=$[24*3600*1000] || total_validity_period=$[30*24*3600*1000]
            tmp_up_timestamp_1="$(echo $(def_json $ck_api_type JD_COOKIE $i remarks) | grep -Eo '@@\d{13}' | grep -Eo '\d{13}' | head -1)"
            tmp_up_timestamp_2="$[$(date -d "$(def_json $ck_api_type JD_COOKIE $i $remote_update_timestamp)" +%s%N)/1000000]"
            timestamp_ms="$[$(date +%s%N)/1000000]"
            remain_validity_period=$[total_validity_period-timestamp_ms+tmp_up_timestamp_1]
            if [[ $remain_validity_period -lt 0 ]]; then
                timestamp_ms="$[$(date +%s%N)/1000000]"
                remain_validity_period=$[total_validity_period-timestamp_ms+tmp_up_timestamp_2]
            fi
            valid_time=$(UTC $remain_validity_period)
            [[ ! ${value[i]} =~ app_open ]] && [[ $remain_validity_period -lt 86400000 ]] && ck_validity_lt_1day[i]="${full_name[$j]}\n"
            if [[ $NOTIFY_VALID_TIME = 1 || $NOTIFY_VALID_TIME = 2 ]]; then
                ck_validity[i]="${full_name[$j]} $(echo $valid_time | perl -pe '{s|([\d]*[^\d]+).*|\1|}')\n"
                [[ $notify = on ]] && echo -e "${emoji_DATE} 账号有效期$valid_time"
            fi
            validity_day[$j]=$[remain_validity_period/86400000]
            validity_less_then_day[$j]=$[(remain_validity_period+86400000)/86400000]
            last_validity_day[$j]="$(def_json_value "$json_path/CK_WxPusherUid.json" validity_day "pin=$j;" | head -1)"
            if [[ $notify_valid_period ]]; then
                last_validity_period=$[last_validity_day[$j]*86400000]
                if [[ $remain_validity_period -lt $last_validity_period ]] && [[ $remain_validity_period -le $notify_valid_period ]] && [[ ! ${value[i]} =~ app_open ]]; then
                    [[ $notify = on ]] && [[ $NOTIFY_VALID_TIME = 1 || $NOTIFY_VALID_TIME = 2 ]] && echo -e "${emoji_SOS} 账号有效期不足${validity_less_then_day[$j]}天"
                    log_one_to_one_validity_day $i " ${full_name[$j]}"
                fi
            fi
            if [[ $remain_validity_period -lt $wskey_update_validity_period ]] && [[ ${wskey_status[$j]} = 0 ]]; then
                [[ $notify = on ]] && echo -e "${emoji_SOS} 账号有效期不足$WSKEY_UPDATE_VALIDITY_HOUR小时，触发强制JD_WSCK转换"
                value[i]=${jd_cookie}
                ck_validity[i]="${full_name[$j]} 账号有效期1天\n"
                validity_day[$j]="0"
                timestamp_ms="$[$(date +%s%N)/1000000]"
                if [[ ${Uid[$j]} ]]; then
                    remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms@@${Uid[$j]}"
                else
                    remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms"
                fi
                ql_update_env_api $ck_api_type JD_COOKIE "${value[i]}" $(eval echo \${$remote_id[i]}) "${remarks_new[$j]}" "更新环境变量值"
                echo -e ""
            fi
        else
            validity_day[$j]="0"
            unset ck_validity_lt_1day[i]
            unset ck_validity[i]
        fi
    }

    # 生成 CK_WxPusherUid.json 或 CK_WxPusherUid_Sample.json 模板
    wxpusher_json(){
        local i=$1
        local notify=$2
        local j=${pin[i]}
        local timestamp_ms NickName_Json remarks_id_Json msg
        timestamp_ms="$(echo $(def_json $ck_api_type JD_COOKIE $i remarks) | grep -Eo '@@\d{13}' | grep -Eo '\d{13}' | head -1)"
        if [[ $timestamp_ms ]] && [[ ! ${Uid[$j]} ]]; then
            if [[ $CK_WxPusherUid = 1 || $CK_WxPusherUid = 2 ]]; then
                ck_undocked_uid[i]="${full_name[$j]}\n" && [[ $notify = on ]] && echo -e "${emoji_SOS} WxPusher UID未对接完成"
            fi
        elif [[ ! ${Uid[$j]} ]]; then
            if [[ $CK_WxPusherUid = 1 || $CK_WxPusherUid = 2 ]]; then
                ck_no_uid[i]="${full_name[$j]}\n" && [[ $notify = on ]] && echo -e "${emoji_NONE} 未录入WxPusher UID"
            fi
        elif [[ ${Uid[$j]} ]]; then
            if [[ ! $timestamp_ms ]] || [[ ! ${tmp_Uid_1[$j]} ]]; then
                if [[ ! $timestamp_ms ]]; then
                    timestamp_ms="$[$(date -d "$(def_json $ck_api_type JD_COOKIE $i $remote_update_timestamp)" +%s%N)/1000000]"
                    if [[ ! ${tmp_Uid_1[$j]} ]]; then
                        msg="将WxPusher UID同步至JD_COOKIE备注"
                    else
                        msg="补全JD_COOKIE备注时间戳"
                    fi
                fi
                remarks_new[$j]="${remarks_id[$j]}@@$timestamp_ms@@${Uid[$j]}"
                ql_update_env_api $ck_api_type JD_COOKIE "${value[i]}" $(eval echo \${$remote_id[i]}) "${remarks_new[$j]}" "${msg}" && echo -e ""
            fi
        fi
        NickName_Json="$(spc_sym_tr ${NickName[$j]})"
        remarks_id_Json="$(spc_sym_tr ${remarks_id[$j]})"
        [[ ${ck_status[$j]} ]] && CK_WxPusherUid_Json[i]="{\n\t\"序号\": \"${sn[i]}\",\n\t\"NickName\": \"$NickName_Json\",\n\t\"JD_COOKIE\": \"${value[i]}\",\n\t\"status\": ${ck_status[$j]},\n\t\"validity_day\": ${validity_day[$j]},\n\t\"remarks\": \"$remarks_id_Json\",\n\t\"JD_WSCK\": \"${wskey_value[$j]}\",\n\t\"wskey_status\": ${wskey_status[$j]},\n\t\"pin\": \"$j\",\n\t\"pt_pin\": \"${pt_pin[i]}\",\n\t\"Uid\": \"${Uid[$j]}\"\n},\n"
    }

    # 同步备注名
    sync_nick_to_ck(){
        local i=$1
        local notify=$2
        local j=${pin[i]}
        # 将昵称更新至 JD_COOKIE 的备注
        if [[ $NICKNAME_REMARK_SYNC = 1 ]]; then
            if [[ ! "${remarks_ori[$j]}" =~ "${NickName[$j]}" ]]; then
                remarks_ori_id="$(echo ${remarks_id[$j]} | awk -F '(' '{print $1}')"
                remarks_id[$j]="$remarks_ori_id(${NickName[$j]})"
                if [[ ! ${remarks_new[$j]} ]]; then
                    remarks_new[$j]="$(echo ${remarks_ori[$j]} | perl -pe '{s|^((?!@@(([\d]{13}\|UID_[\w]{28}))).)*|'${remarks_id[$j]}'|}')"
                else
                    remarks_new[$j]="$(echo ${remarks_new[$j]} | perl -pe '{s|^((?!@@(([\d]{13}\|UID_[\w]{28}))).)*|'${remarks_id[$j]}'|}')"
                fi
                ql_update_env_api $ck_api_type JD_COOKIE "${value[i]}" "$(eval echo \${$remote_id[i]})" "${remarks_new[$j]}" "补全JD_COOKIE备注昵称" && echo -e ""
                #Get_Full_Name $i
            fi
        fi

        # 同步 JD_COOKIE 和 JD_WSCK 的同 pin 备注名双向同步
        if [[ $WSKEY_REMARK_SYNC = 1 ]]; then
            if [[ ${remarks_id[$j]} ]]; then
                if [[ ! ${remarks_ori[$j]} ]]; then
                    ql_update_env_api $ck_api_type JD_COOKIE "${value[i]}" $(eval echo \${$remote_id[i]}) "${remarks_new[$j]}" "添加JD_COOKIE备注" && echo -e ""
                    #Get_Full_Name $i
                fi
                if [[ ${wskey_value[$j]} ]] && [[ ${remarks_id[$j]} != ${wskey_remarks[$j]} ]]; then
                    ql_update_env_api $wskey_api_type JD_WSCK "${wskey_value[$j]}" "${wskey_id[$j]}" "${remarks_id[$j]}" "更新JD_WSCK备注" && echo -e ""
                    #Get_Full_Name $i
                fi
            fi
        fi
    }

    ## 失效账号/重启账号一对一通知
    log_one_to_one(){
        local i=$1
        local j=${pin[i]}
        local process=$2
        local status=$3
        local full_name=$4
        local title content_1 content_2 content_3 content_4 content_5 summary content uid
        if [[ $(echo $WP_APP_TOKEN_ONE|grep -Eo 'AT_(\w{32})') ]]; then
            [[ $NOTIFY_DISABLE_MainWP_UID = 0 || $NOTIFY_DISABLE_MainWP_UID = 2 ]] && local MainWP_UID=""
            if [[ $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]] && [[ ${Uid[$j]} ]]; then
                if [[ $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') = ${Uid[$j]} ]]; then
                    uid="$(echo ${Uid[$j]} | perl -pe '{s|^|\"|; s|$|\"|}')"
                else
                    uid="$(echo $MainWP_UID,${Uid[$j]} | perl -pe '{s|^|\"|; s|,|\",\"|g; s|$|\"|}')"
                fi
            elif [[ ! $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]] && [[ ${Uid[$j]} ]]; then
                uid="$(echo ${Uid[$j]} | perl -pe '{s|^|\"|; s|$|\"|}')"
            elif [[ $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]] && [[ ! ${Uid[$j]} ]]; then
                uid="$(echo $MainWP_UID | perl -pe '{s|^|\"|; s|$|\"|}')"
            fi
            if [[ "$uid" ]]; then
                title="Cookie $process通知"
                content_1="$full_name 账号$status并$process"
                #[[ $wskey_end = 0 ]] && [[ ${wskey_invalid[i]} ]] && content_2="，JD_WSCK(wskey) 失效或转换失败"
                #[[ ${wskey_invalid[i]} ]] && content_2="，JD_WSCK(wskey) 失效或转换失败"
                [[ ${wskey_invalid[i]} ]] && content_2="，JD_WSCK(wskey) 失效"
                [[ ${ck_none_wskey[i]} ]] && content_3="，未录入 JD_WSCK(wskey)"
                [[ ${ck_undocked_uid[i]} ]] && content_4="，WxPusher 未对接完成"
                [[ ${ck_no_uid[i]} ]] && content_5="，未录入 WxPusher UID"
                summary="$content_1$content_2$content_3$content_4$content_5"
                content="$content_top$content_1$content_2$content_3$content_4$content_5$content_bot"
                WxPusher_notify_api $WP_APP_TOKEN_ONE "$uid" "$title" "$summary" "$content"
            fi
        fi
    }

    ## 失效账号/重启账号一对一通知
    log_one_to_one_validity_day(){
        local i=$1
        local j=${pin[i]}
        local full_name=$2
        local title content_1 summary content uid
        if [[ $(echo $WP_APP_TOKEN_ONE|grep -Eo 'AT_(\w{32})') ]]; then
            [[ $NOTIFY_DISABLE_MainWP_UID = 0 || $NOTIFY_DISABLE_MainWP_UID = 1 ]] && local MainWP_UID=""
            if [[ $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]] && [[ ${Uid[$j]} ]]; then
                if [[ $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') = ${Uid[$j]} ]]; then
                    uid="$(echo ${Uid[$j]} | perl -pe '{s|^|\"|; s|$|\"|}')"
                else
                    uid="$(echo $MainWP_UID,${Uid[$j]} | perl -pe '{s|^|\"|; s|,|\",\"|g; s|$|\"|}')"
                fi
            elif [[ ! $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]] && [[ ${Uid[$j]} ]]; then
                uid="$(echo ${Uid[$j]} | perl -pe '{s|^|\"|; s|$|\"|}')"
            elif [[ $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]] && [[ ! ${Uid[$j]} ]]; then
                uid="$(echo $MainWP_UID | perl -pe '{s|^|\"|; s|$|\"|}')"
            fi
            if [[ "$uid" ]]; then
                title="Cookie 有效期不足 ${validity_less_then_day[$j]} 天通知"
                content_1="$full_name 账号有效期不足 ${validity_less_then_day[$j]} 天"
                summary="$content_1"
                content="$content_top$content_1$content_bot"
                WxPusher_notify_api $WP_APP_TOKEN_ONE "$uid" "$title" "$summary" "$content"
            fi
        fi
    }

    local wsck_to_ck_code wsck_to_ck_msg timestamp_ms tokenKey host
    for i in ${!value[@]}; do
        local j=${pin[i]}
        local ckck_code ckck_msg ck_status_chinese ck_process_chinese wskey_status_chinese wskey_process_chinese
        Checksum_code[i]=${pin[i]}
        echo ""
        Get_Full_Name $i
        echo -e "$line"
        echo -e "ߧᢀ�쾤{full_name[$j]} "
        check_ck $i on
        check_wskey $i on
        check_validity $i on
        wxpusher_json $i on
        sync_nick_to_ck $i on
        local wskey_pin_sub="$(def_sub $wskey_api_type JD_WSCK value "pin=$j;")"
        [[ "$wskey_pin_sub" ]] && for k in $wskey_pin_sub; do unset wskey_array[k]; done
        if [[ ${ck_status[$j]} = 0 && ${status_last[$j]} = 1 ]] || [[ ${ck_status[$j]} = 1 && ${status_last[$j]} = 0 ]] || [[ ${ck_status[$j]} = 1 && $NOTIFY_WxPusher_Schedule = on ]]; then
            if [[ ${ck_status[$j]} = 0 && ${status_last[$j]} = 1 ]]; then
                ck_valid_this_time[i]="${full_name[$j]}\n"
            elif [[ ${ck_status[$j]} = 1 && ${status_last[$j]} = 0 ]]; then
                ck_invalid_this_time[i]="${full_name[$j]}\n"
            fi
            log_one_to_one $i "$ck_process_chinese" "$ck_status_chinese" " ${full_name[$j]}"
        fi
        echo -e "$line"
    done

    if [[ ${#wskey_array[@]} -gt 0 ]]; then
        echo -e "\n${emoji_MSG} 检测到还未转换 JD_COOKIE 的 JD_WSCK(wskey)，开始进行 wskey 转换 ...\n"
        local notify="on"
        for other_wskey in ${wskey_array[@]}; do
            echo -e "$line"
            let i++
            sn[i]=$((i + 1))
            pin[i]=$(echo $other_wskey | perl -pe "{s|.*pin=([^;\； ]+)(?=;?).*|\1|}")
            pt_pin[i]=$(urldecode "${pin[i]}")
            j=${pin[i]}
            Get_Full_Name $i
            [[ $other_wskey =~ "wskey=" ]] && other_wskey="pin=$j;$(echo $other_wskey | grep -Eo 'wskey=[^;\； ]+' | head -1);"
            wskey_value[$j]=$other_wskey
            wsck_to_ck ${wskey_value[$j]}
            wskey_analysis $i on
            eval $remote_id[i]="$(def_json $ck_api_type JD_COOKIE $i $remote_id)"
            check_validity $i
            wxpusher_json $i
            sync_nick_to_ck $i
            echo -e ""
            log_one_to_one $i "$ck_process_chinese" "$ck_status_chinese" " ${full_name[$j]}"
            echo -e "$line"
        done
    fi
}

Load_UA_cache(){
    [[ ${#UA_cache_array[@]} -gt 0 ]] && rand=$[$RANDOM % ${#UA_cache_array[@]}] && UA=${UA_cache_array[rand]}
}

Load_sign_cache(){
    [[ ${#sign_cache_array[@]} -gt 0 ]] && rand=$[$RANDOM % ${#sign_cache_array[@]}] && sign=${sign_cache_array[rand]}
}

Get_UA(){
    # 获取 User-Agent
    wskey_sign_api=("http://api.momoe.ml/" "https://api.momoe.ml/" "https://api.iliya.cf/")
    ran_sub="$(random 0 $[${#wskey_sign_api[*]}-1])"
    for sub in $ran_sub; do
        host=${wskey_sign_api[sub]}
        local url="${host}api/check_api"
        local api=$(
            curl -s -k --connect-timeout 20 --retry 3 --noproxy "*" "$url" \
                -H "Authorization: Bearer Shizuku" \
                -H "User-Agent: python_shizuku"
        )

        if [[ $api =~ \"code\" ]]; then
            local code=$(echo $api | jq -r .code)
            if [[ $code == 200 ]]; then
                if [[ $api =~ \"User-Agent\" ]]; then
                    UA=$(echo $api | jq -r '.["User-Agent"]')
                    break
                fi
            else
                Load_UA_cache
            fi
        fi
    done
}

# 获取 Sign 参数(jds 接口)
Get_Sign_jds(){
    # 获取 Sign 参数
    local url="https://api.zhezhe.cf/jd/gentoken"
    local api=$(
        curl -s -k --connect-timeout 20 --retry 3 --noproxy "*" "${url}" \
            -H "Content-Type: application/json" \
            -d '{"url": "https://home.m.jd.com/myJd/newhome.action"}'
    )

    if [[ $api =~ \"code\" ]]; then
        local code=$(echo $api | jq -r .code)
        if [[ $code == 200 ]]; then
            if [[ $api == *sign* ]]; then
                export sign=$(echo $api | jq -r .data.sign)
            else
                Load_sign_cache
            fi
        else
            Load_sign_cache
        fi
    fi
}

# 获取 Sign 参数(Zy143L 接口)
Get_Sign_Zy143L(){
    if [[ $UA ]]; then
        local functionId clientVersion build client partner oaid sdkVersion lang harmonyOs networkType uemps ext ef ep st sv
        wskey_sign_api=("http://api.momoe.ml/" "https://api.momoe.ml/" "https://api.iliya.cf/")
        ran_sub="$(random 0 $[${#wskey_sign_api[*]}-1])"
        for sub in $ran_sub; do
            host=${wskey_sign_api[sub]}
            local url="${host}genToken"
            local api=$(
                curl -s -k --connect-timeout 20 --retry 3 --noproxy "*" "$url" \
                    -H "User-Agent: $UA"
            )

            if [[ $api =~ \"code\" ]]; then
                local code=$(echo $api | jq -r .code)
                if [[ $code == 200 ]]; then
                    wsck_to_ck_code="3" && wsck_to_ck_msg="User-Agent 错误"
                else
                    wsck_to_ck_code="3" && wsck_to_ck_msg="User-Agent 未知错误"
                fi
                [[ $wsck_to_ck_code = 3 ]] && wskey_process $wsck_to_ck_code
            else
                #for params in functionId clientVersion build client partner oaid sdkVersion lang harmonyOs networkType uemps ext ef ep st sign sv; do
                for params in functionId clientVersion client ef ep st sign sv; do
                    if [[ $api =~ \"$params\" ]]; then
                        if [[ $params = ext || $params = ep ]]; then
                            eval $params='$(urlencode $(echo $api | jq -r .$params))'
                        else
                            eval $params='$(echo $api | jq -r .$params)'
                        fi
                    fi
                done

                if [[ ${clientVersion} && ${client} && ${ef} && ${ep} && ${st} && ${sign} && ${sv} ]]; then
                    body="body=%7B%22to%22%3A%22https%253a%252f%252fplogin.m.jd.com%252fjd-mlogin%252fstatic%252fhtml%252fappjmp_blank.html%22%7D&"
                    export sign="${body}clientVersion=${clientVersion}&client=${client}&ef=${ef}&ep=${ep}&st=${st}&sign=${sign}&sv=${sv}"
                    break
                else
                    Load_sign_cache
                    break
                fi
            fi
        done
    fi
}

# 生成 CK_Sign_UA.json 的缓存数据
Dump_Sign_UA_json(){
    local num UA sign rand ran_sleep
    Sign_UA_array=()
    { for ((num = 0; num <= 19; num++)); do
        Get_UA
        Get_Sign_Zy143L
        [[ ! ${sign} ]] && Get_Sign_jds
        if [[ $UA && ! ${Sign_UA_Json[num]} =~ $UA ]] && [[ ${sign} && ! ${Sign_UA_Json[num]} =~ ${sign} ]]; then
            UA="$(spc_sym_tr $UA)"
            Sign_UA_Json[num]="{\n\t\"sign\": \"${sign}\",\n\t\"UA\": \"${UA}\"\n},\n"
        elif [[ ! $UA ]]; then
            [[ ${#UA_array[@]} -gt 0 ]] && rand=$[$RANDOM % ${#UA_array[@]}] && UA=${UA_array[rand]} && unset UA_array[rand] && UA_array=(${UA_array[@]})
            if [[ $UA && ! ${Sign_UA_Json[num]} =~ $UA ]] && [[ ${sign} && ! ${Sign_UA_Json[num]} =~ ${sign} ]]; then
                UA="$(spc_sym_tr $UA)"
                Sign_UA_Json[num]="{\n\t\"sign\": \"${sign}\",\n"
            fi
        fi
        ran_sleep="$(random 10 30)"
        sleep 10
    done

    [[ ${Sign_UA_Json[*]} ]] && Sign_UA_Json_All="$(print_array "${Sign_UA_Json[*]}" | perl -pe '{s|,\\n$|\\n|g; s|{\\n|  {\\n|g; s|\\n}|\\n  }|g}')"
    [[ $Sign_UA_Json_All ]] && Sign_UA_Json_content="[\n$Sign_UA_Json_All]"
    [[ $Sign_UA_Json_content ]] && echo -e "$Sign_UA_Json_content" > $json_path/CK_Sign_UA.json
    [[ ! -d $json_log_path/.CK_Sign_UA ]] && mkdir -p $json_log_path/.CK_Sign_UA
    [[ $Sign_UA_Json_content ]] && echo -e "$Sign_UA_Json_content" > $json_log_path/.CK_Sign_UA/CK_Sign_UA_`date "+%Y-%m-%d-%H-%M-%S"`.log; } &
}

# 获取 tokenKey 令牌
Get_tokenKey(){
    if [[ ${sign} && $UA ]]; then
        local url="https://api.m.jd.com/client.action?functionId=genToken&${sign}"
        local api=$(
            curl -s -k --connect-timeout 20 --retry 3 --noproxy "*" "$url" \
                -H "Cookie: $wskey" \
                -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" \
                -H "charset: UTF-8" \
                -H "Accept-Encoding: br,deflate" \
                -H "User-Agent: $UA"
        )

        if [[ $api =~ \"code\" ]]; then
            local code=$(echo $api | jq -r .code)
            if [[ $code == 0 ]]; then
                if [[ $api == *tokenKey* ]]; then
                    tokenKey=$(echo $api | jq -r .tokenKey)
                    [[ $tokenKey = xxx ]] && wsck_to_ck_code="4" && wsck_to_ck_msg="JD_WSCK(wskey)失效"
                else
                    wsck_to_ck_code="6" && wsck_to_ck_msg="获取tokenKey令牌失败"
                fi
            elif [[ $code == 1 ]]; then
                wsck_to_ck_code="2" && wsck_to_ck_msg="签名(Sign)缺少参数" && wskey_process $wsck_to_ck_code
            elif [[ $code == 600 ]]; then
                wsck_to_ck_code="2" && wsck_to_ck_msg="签名(Sign)参数错误" && wskey_process $wsck_to_ck_code
            else
                wsck_to_ck_code="2" && wsck_to_ck_msg="签名(Sign)未知错误" && wskey_process $wsck_to_ck_code
            fi
        fi
    fi
}

# 获取 pt_pin 和 pt_key
Get_jdCookie(){
    if [[ $tokenKey && $tokenKey != xxx ]]; then
        local url="https://un.m.jd.com/cgi-bin/app/appjmp?tokenKey=${tokenKey}&to=https://home.m.jd.com/myJd/newhome.action"
        local api=$(
            curl -I -s -k --connect-timeout 20 --retry 3 --noproxy "*" "${url}" \
                -H "Connection: Keep-Alive" \
                -H "Accept: */*" \
                -H "User-Agent: $UA" \
                -H "Accept-Language: zh-Hans-CN;q=1, en-CN;q=0.9" \
                -H "Content-Type: application/x-www-form-urlencoded"
        )

        if [[ "$api" =~ "HTTP/2 302" ]]; then
            if [[ "$api" == *pt_key=app_open* ]]; then
                wsck_to_ck_code="0" && wsck_to_ck_msg="JD_WSCK(wskey)转换JD_COOKIE成功" && jd_cookie="$(echo "$api" | grep -Eo 'pt_key=[^; ]+;')$(echo "$api" | grep -Eo 'pt_pin=[^; ]+;')"
            elif [[ "$api" == *pt_key=\;* ]]; then
                wsck_to_ck_code="1" && wsck_to_ck_msg="tokenKey令牌错误" && wskey_process $wsck_to_ck_code
            else
                wsck_to_ck_code="4" && wsck_to_ck_msg="JD_WSCK(wskey)失效"
            fi
        else
            wsck_to_ck_code="5" && wsck_to_ck_msg="JD_WSCK(wskey)转换API访问失败"
        fi
    fi
}

## wskey 转换的流程组合
wskey_process(){
    local ran_sub sub host params body
    jd_cookie=""
    wsck_to_ck_code=""
    wsck_to_ck_msg=""
    case $1 in
        1)
            Get_Sign_Zy143L
            [[ ! ${sign} ]] && Get_Sign_jds
            Get_tokenKey
            Get_jdCookie
            ;;
        2)
            Get_Sign_Zy143L
            [[ ! ${sign} ]] && Get_Sign_jds
            Get_tokenKey
            Get_jdCookie
            ;;
        3)
            Get_UA
            Get_Sign_Zy143L
            [[ ! ${sign} ]] && Get_Sign_jds
            ;;
        4)
            Get_tokenKey
            Get_jdCookie
            ;;
        *)
            Get_UA
            Get_Sign_Zy143L
            [[ ! ${sign} ]] && Get_Sign_jds
            Get_tokenKey
            Get_jdCookie
            ;;
    esac
    [[ ! ${wsck_to_ck_code} ]] && wsck_to_ck_msg="网络连接故障"
}

## 检测到失效账号，自动使用JD_WSCK(wskey) 转换 JD_COOKIE
wsck_to_ck(){
    local wskey=$1
    local rand
    Load_UA_cache
    Load_sign_cache
    [[ ${sign} && $UA ]] && wskey_process 4 || wskey_process
}

## 检测到失效账号，或还未转换为 JD_COOKIE 的 JD_WSCK(wskey)，则搜索或下载wskey转换脚本进行转换
wsck_to_ck_bak(){
    # 主站链接数组
    host_url_array=(
      https://raw.fastgit.org
      https://raw.githubusercontent.com
    )

    # 筛选主站链接
    define_url(){
        for i in $@; do
            local url="$i"
            local api=$(
                curl -sI --connect-timeout 30 --retry 3 --noproxy "*" -o /dev/null -s -w %{http_code} "$url"
            )
            code=$(echo $api)
            [[ $code == 200 || $code == 301 ]] && echo "$url" && break
        done
    }

    ## 文件下载工具
    download_file(){
        get_remote_filesize(){
            local url="$1"
            curl -sI --connect-timeout 30 --retry 3 --noproxy "*" "$url" | grep -i Content-Length | awk '{print $2}'
        }

        get_local_filesize(){
           stat -c %s $1
        }

        get_md5(){
            md5sum $1 | cut -d ' ' -f1
        }

        local url="$1"
        local file_path="$2"
        file="${url##*/}"

        local api=$(
            curl -sI --connect-timeout 30 --retry 3 --noproxy "*" -o /dev/null -s -w %{http_code} "$url"
        )

        code=$(echo $api)
        if [[ $code == 200 || $code == 301 ]]; then
            curl -C - -s --connect-timeout 30 --retry 3 --noproxy "*" "$url" -o $file_path/tmp_$file
            if [[ -f "$file_path/tmp_$file" ]]; then
                if [[ $(get_remote_filesize $url) -eq $(get_local_filesize $file_path/tmp_$file ) ]]; then
                    if [[ -f "$file_path/$file" ]]; then
                        [[ "$(get_md5 $file_path/$file)" != "$(get_md5 $file_path/tmp_$file)" ]] && mv -f $file_path/tmp_$file $file_path/$file || rm -rf $file_path/tmp_$file
                    else
                        mv -f $file_path/tmp_$file $2/$file
                    fi
                fi
            fi
        else
            echo "无法链接下载链接，请稍后再试！"
        fi
    }

    ## 选择python3还是node
    define_program() {
        local first_param=$1
        if [[ $first_param == *.js ]]; then
            which_program="node"
        elif [[ $first_param == *.py ]]; then
            which_program="python3"
        elif [[ $first_param == *.sh ]]; then
            which_program="bash"
        elif [[ $first_param == *.ts ]]; then
            which_program="ts-node-transpile-only"
        else
            which_program=""
        fi
    }

    progress_wskey_scr(){
        if [[ $diy_wskey_scr ]]; then
            [[ $diy_wskey_scr =~ $json_path ]] && wskey_scr="$diy_wskey_scr" || wskey_scr="$json_path/$diy_wskey_scr"
        else
            wskey_scr="$(find $json_path -type f -name *wskey*.py | head -1)"
        fi
        [[ ! $WSKEY_SCR_URL ]] && host_url="$(define_url ${host_url_array[@]})" && WSKEY_SCR_URL="$host_url/Zy143L/wskey/main/wskey.py"
        if [[ -f $wskey_scr ]]; then
            if [[ "$wskey_scr" = "$json_path/wskey.py" && $CHECK_UPDATE_WSKEY_SCR = 1 ]]; then
                echo -e "# 已检索到 wskey.py ，开始检查更新 wskey 转换脚本 ..."
                download_file "$WSKEY_SCR_URL" $json_path >/dev/null 2>&1
            else
                echo -e "# 已搜索到 wskey 转换脚本，开始执行 wskey 转换 ..."
            fi
            define_program $wskey_scr
            $which_program $wskey_scr
            wskey_end="0"
            echo -e ""
        else
            if [[ $DOWNLOAD_WSKEY_SCR = 1 ]]; then
                echo -e "# 未搜索到脚本，开始下载 wskey 转换脚本 ..."
                download_file "$WSKEY_SCR_URL" $json_path >/dev/null 2>&1
                wskey_scr="$file"
                if [[ -f "$json_path/$wskey_scr" ]]; then
                   echo -e "# wskey 转换脚本下载成功，开始执行 wskey 转换 ..."
                   define_program "$json_path/$wskey_scr"
                   $which_program "$json_path/$wskey_scr"
                   wskey_end="0"
                   echo -e ""
                else
                   echo -e "# wskey 转换脚本下载失败，跳过 wskey 转换 ..."
                   echo -e ""
                fi
            else
                echo -e "# 未搜索到 wskey 转换脚本，跳过 wskey 转换 ..."
                echo -e ""
            fi
        fi
    }

    if [[ $WSKEY_TO_CK = 1 ]]; then
        if [[ ${#wskey_value[@]} -gt 0 ]] && [[ ${#ck_invalid[@]} -gt 0 ]]; then
            echo -e "# 检测到失效账号，开始搜索 wskey 转换脚本 ..."
            progress_wskey_scr
        elif [[ ${#wskey_array[@]} -gt 0 ]]; then
            echo -e "# 检测到还未转换 JD_COOKIE 的 JD_WSCK(wskey)，开始搜索 wskey 转换脚本 ..."
            progress_wskey_scr
        fi
    fi
}

# 通知内容整理及通知
content_notify(){
    # 导出最终账号有效性结果并一对一通知
    export_valid_result(){
        local i=$1
        local j=${pin[i]}
        local ck_status_chinese ck_process_chinese
        if [[ ${final_status[$j]} = 0 ]]; then
            ck_status[$j]="0"
            ck_valid[i]="${full_name[$j]}\n"
            unset ck_invalid[i]
            ck_status_chinese="正常"
            ck_process_chinese="启用"
            if [[ ! ${status_last[$j]} ]]; then
                ck_added[i]="${full_name[$j]}\n"
                ck_status_chinese="生效"
                ck_process_chinese="添加"
                log_one_to_one $i "$ck_process_chinese" "$ck_status_chinese" " ${full_name[$j]}"
            elif [[ ${final_status[$j]} != ${status_last[$j]} && ${status_last[$j]} = 1 ]]; then
                ck_valid_this_time[i]="${full_name[$j]}\n"
                ck_status_chinese="生效"
                ck_process_chinese="重启"
                log_one_to_one $i "$ck_process_chinese" "$ck_status_chinese" " ${full_name[$j]}"
            fi
        elif [[ ${final_status[$j]} = 1 ]]; then
            ck_status[$j]="1"
            #[[ $wskey_end = 0 ]] && [[ ${wskey_value[$j]} ]] && wskey_invalid[i]="${full_name[$j]}\n"
            ck_invalid[i]="${full_name[$j]}\n"
            unset ck_valid[i]
            ck_status_chinese="失效"
            ck_process_chinese="禁用"
            if [[ ${final_status[$j]} != ${status_last[$j]} && ${status_last[$j]} = 0 ]]; then
                ck_invalid_this_time[i]="${full_name[$j]}\n"
                log_one_to_one $i "$ck_process_chinese" "$ck_status_chinese" " ${full_name[$j]}"
            fi
        fi
    }

    # 整理通知内容
    sort_notify_content(){
        echo -e "${emoji_CHART} 正在整理通知内容，请耐心等待 ...\n"
        #gen_pt_pin_array
        #for i in ${!value[@]}; do
        #    local j=${pin[i]}
            # 获取上次 JD_COOKIE 的检测状态
        #    status_last[$j]="$(def_json_value "$json_path/CK_WxPusherUid.json" status "pin=$j;")"
        #    [[ ! ${status_last[$j]} ]] && status_last[$j]=${status_ori[$j]}
        #    final_status[$j]="$(def_json $ck_api_type JD_COOKIE $i status)"
        #    if [[ ${Checksum_code[i]} = ${pin[i]} ]]; then
        #        [[ ${ck_status[$j]} != 2 ]] && [[ "${final_status[$j]}" == "${status_last[$j]}" ]] && [[ "${final_status[$j]}" == "${ck_status[$j]}" ]] && [[ ${final_status[$j]} = 0 ]] && continue
        #    fi
        #    Get_Full_Name $i
        #    export_valid_result $i
        #    check_wskey $i
        #    check_validity $i
        #    wxpusher_json $i
        #    sync_nick_to_ck $i
        #done

        invalid_all="$(print_array "${ck_invalid[*]}")"
        [[ $invalid_all ]] && notify_content_invalid_all="ߒ밟⫢쨥䱦刨䦥﷨共${#ck_invalid[@]}个)✨ߒ밟⫝̸n$invalid_all\n"
        content_1=$notify_content_invalid_all

        ck_invalid_this_time_all="$(print_array "${ck_invalid_this_time[*]}")"
        [[ $ck_invalid_this_time_all ]] && notify_content_ck_invalid_this_time_all="ߒ밟⫢쨦쬦졤process_notify_type_1账号(共${#ck_invalid_this_time[@]}个)✨ߒ밟⫝̸n$ck_invalid_this_time_all\n"
        content_2=$notify_content_ck_invalid_this_time_all

        ck_added_all="$(print_array "${ck_added[*]}")"
        [[ $ck_added_all ]] && notify_content_ck_added_all="ߒ밟⫢쨦쬦졦氥➨䦥﷨共${#ck_added[@]}个)✨ߒ밟⫝̸n$ck_added_all\n"
        content_3=$notify_content_ck_added_all

        ck_valid_this_time_all="$(print_array "${ck_valid_this_time[*]}")"
        [[ $ck_valid_this_time_all ]] && notify_content_ck_valid_this_time_all="ߒ밟⫢쨦쬦졤process_notify_type_0账号(共${#ck_valid_this_time[@]}个)✨ߒ밟⫝̸n$ck_valid_this_time_all\n"
        content_4=$notify_content_ck_valid_this_time_all

        validity_lt_1day_all="$(print_array "${ck_validity_lt_1day[*]}")"
        [[ $validity_lt_1day_all ]] && notify_content_validity_lt_1day_all="ߒ밟⫢쨨䦥﷦쉦刦쟤荨泱天的账号(共${#ck_validity_lt_1day[@]}个)✨ߒ밟⫝̸n$validity_lt_1day_all\n"
        [[ $NOTIFY_VALID_TIME = 1 ]] && content_5=$notify_content_validity_lt_1day_all

        wskey_invalid_all="$(print_array "${wskey_invalid[*]}")"
        #[[ $wskey_invalid_all ]] && notify_content_wskey_invalid_all="ߒ밟⫢쨊D_WSCK(wskey)失效或转换失败的账号(共${#wskey_invalid[@]}个)✨ߒ밟⫝̸n$wskey_invalid_all\n"
        [[ $wskey_invalid_all ]] && notify_content_wskey_invalid_all="ߒ밟⫢쨊D_WSCK(wskey)失效的账号(共${#wskey_invalid[@]}个)✨ߒ밟⫝̸n$wskey_invalid_all\n"
        [[ $NOTIFY_WSKEY_NO_EXIST = 1 ]] && content_6=$notify_content_wskey_invalid_all

        ck_none_wskey_all="$(print_array "${ck_none_wskey[*]}")"
        [[ $ck_none_wskey_all ]] && notify_content_ck_none_wskey_all="ߒ밟⫢쨦쪥핥奊D_WSCK(wskey)的账号(共${#ck_none_wskey[@]}个)✨ߒ밟⫝̸n$ck_none_wskey_all\n"
        [[ $NOTIFY_WSKEY_NO_EXIST = 1 ]] && content_7=$notify_content_ck_none_wskey_all

        ck_undocked_uid_all="$(print_array "${ck_undocked_uid[*]}")"
        [[ $ck_undocked_uid_all ]] && notify_content_ck_undocked_uid_all="ߒ밟⫢쨗xPusher未对接完成的账号(共${#ck_undocked_uid[@]}个)✨ߒ밟⫝̸n$ck_undocked_uid_all\n"
        [[ $CK_WxPusherUid = 1 ]] && content_8=$notify_content_ck_undocked_uid_all

        ck_no_uid_all="$(print_array "${ck_no_uid[*]}")"
        [[ $ck_no_uid_all ]] && notify_content_ck_no_uid_all="ߒ밟⫢쨦쪥핥套xPusher UID的账号(共${#ck_no_uid[@]}个)✨ߒ밟⫝̸n$ck_no_uid_all\n"
        [[ $CK_WxPusherUid = 1 ]] && content_9=$notify_content_ck_no_uid_all

        valid_all="$(print_array "${ck_valid[*]}")"
        [[ $valid_all ]] && notify_content_valid_all="ߒ밟⫢쨦�踨䦥﷨共${#ck_valid[@]}个)✨ߒ밟⫝̸n$valid_all\n"
        [[ $NOTIFY_VALID_CK_TYPE = 2 ]] && content_10=$notify_content_valid_all

        validity_all="$(print_array "${ck_validity[*]}")"
        [[ $validity_all ]] && notify_content_validity="ߒ밟⫢쨩Ω勨䦥﷦쉦刦쟨共${#ck_validity[@]}条)✨ߒ밟⫝̸n$validity_all\n"
        [[ $NOTIFY_VALID_TIME = 1 ]] && content_11=$notify_content_validity

        [[ ${CK_WxPusherUid_Json[*]} ]] && CK_WxPusherUid_Json_All="$(print_array "${CK_WxPusherUid_Json[*]}" | perl -pe '{s|,\\n$|\\n|g; s|{\\n|  {\\n|g; s|\\n}|\\n  }|g}')"
        [[ $CK_WxPusherUid_Json_All ]] && CK_WxPusherUid_Json_content="[\n$CK_WxPusherUid_Json_All]"

        # 账号有效性检测结果与上次检测结果一致的处理
        valid_pin=($(def_json_grep_match $ck_api_type JD_COOKIE value '"status": 0'  | perl -pe "{s|.*pt_pin=([^;\； ]+)(?=;?).*|\1|}"))
        invalid_pin=($(def_json_grep_match $ck_api_type JD_COOKIE value '"status": 1'  | perl -pe "{s|.*pt_pin=([^;\； ]+)(?=;?).*|\1|}"))
        if [[ ${#invalid_pin[@]} -gt 0 ]]; then
            if [[ $NOTIFY_SKIP_SAME_CONTENT = 1 ]] && [[ "${invalid_pin[@]}" == "${ori_invalid_pin[@]}" ]]; then
                echo -e "${emoji_MSG} 失效账号与上次检测结果一致，本次不推送。\n"
                content_1=""
            fi
        fi
        if [[ ${#valid_pin[@]} -gt 0 ]]; then
            if [[ $NOTIFY_SKIP_SAME_CONTENT = 1 && "${valid_pin[@]}" == "${ori_valid_pin[@]}" ]]; then
                echo -e "${emoji_MSG} 有效账号与上次检测结果一致，本次不推送。\n"
                content_10=""
            fi
        fi

        display_content="$notify_content_invalid_all$notify_content_ck_invalid_this_time_all$notify_content_ck_added_all$notify_content_ck_valid_this_time_all$notify_content_validity_lt_1day_all$notify_content_wskey_invalid_all$notify_content_ck_none_wskey_all$notify_content_ck_undocked_uid_all$notify_content_ck_no_uid_all$notify_content_valid_all$notify_content_validity"
        notify_content="$content_1$content_2$content_3$content_4$content_5$content_6$content_7$content_8$content_9$content_10$content_11"
    }

    # 推送通知
    sort_notify_content
    echo -e "$display_content"
    local title summary content
    title="Cookie 状态通知"
    #summary="$display_content"
    #content="$content_top$display_content$content_bot"
    summary="$notify_content"
    content="$content_top$notify_content$content_bot"
    if [[ $summary ]]; then
        if [[ $(echo $WP_APP_TOKEN_ONE|grep -Eo 'AT_(\w{32})') && $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]] || [[ $QYWX_KEY ]] || [[ $QYWX_AM ]] || [[ $PUSH_PLUS_TOKEN ]] || [[ $PUSH_PLUS_TOKEN_hxtrip ]] || [[ $TG_BOT_TOKEN && $TG_USER_ID ]]; then
            if [[ $(echo $WP_APP_TOKEN_ONE|grep -Eo 'AT_(\w{32})') && $(echo $MainWP_UID|grep -Eo 'UID_\w{28}') ]]; then
                uids="$(echo $MainWP_UID | perl -pe '{s|^|\"|; s|$|\"|}')"
                WxPusher_notify_api "$WP_APP_TOKEN_ONE" "$uids" "$title" "$summary" "$content"
                echo -e ""
            fi
            if [[ $QYWX_KEY ]]; then
                QYWX_Bot_notify_api "$QYWX_KEY" "$title" "$summary"
                echo -e ""
            fi
            if [[ $QYWX_AM ]]; then
                QYWX_notify_api "$QYWX_AM" "Shell版CK检查工具ckck2" "$title" "$summary" "$content"
                echo -e ""
            fi
            if [[ $PUSH_PLUS_TOKEN ]]; then
                PUSH_PLUS_USER=""
                pushplus_notify_api "$PUSH_PLUS_TOKEN" "$PUSH_PLUS_USER" "$title" "$content"
                echo -e ""
            fi
            if [[ $PUSH_PLUS_TOKEN_hxtrip ]]; then
                PUSH_PLUS_USER_hxtrip=""
                hxtrip_pushplus_notify_api "$PUSH_PLUS_TOKEN_hxtrip" "$PUSH_PLUS_USER_hxtrip" "$title" "$content"
                echo -e ""
            fi
            if [[ $TG_BOT_TOKEN && $TG_USER_ID ]]; then
                Telegram_notify_api "$TG_BOT_TOKEN" "$TG_USER_ID" "$title" "$summary"
                echo -e ""
            fi
        else
            echo -e "${emoji_OUTBOX} 推送通知..." && notify "$title" "$content"
        fi
    fi
}

ckck_program(){
    echo -n "${emoji_MSG} 开始检查账号有效性"
    [[ $NOTIFY_VALID_TIME = 1 || $NOTIFY_VALID_TIME = 2 ]] && echo -e "，预测账号有效期谨供参考 ..." || echo -e " ..."
    declare -A remarks_ori remarks_id remarks_name remarks_new wskey_value wskey_id wskey_remarks wskey_status wskey_status_ori wskey_status_json wskey_status_last tmp_Uid_1 tmp_Uid_2 Uid NickName full_name value_json status_ori status_json ck_status status_last final_status last_validity_day validity_day validity_less_then_day
    pre_work
    verify_ck
    echo ""
    content_notify

    [[ $CK_WxPusherUid_Json_content ]] && echo -e "$CK_WxPusherUid_Json_content" > $json_path/CK_WxPusherUid.json
    [[ ! -d $json_log_path/.CK_WxPusherUid ]] && mkdir -p $json_log_path/.CK_WxPusherUid
    echo -e "$CK_WxPusherUid_Json_content" > $json_log_path/.CK_WxPusherUid/CK_WxPusherUid_`date "+%Y-%m-%d-%H-%M-%S"`.log
}

main() {
    LOCAL_DIR="$(cd $(dirname ${BASH_SOURCE:-$0});pwd)"
    echo -e ""
    echo -e "${emoji_MSG} 当前版本：$Ver\n"
    case $1 in
        0)
            ck_api_type="open"
            wskey_api_type="closure"
            if [[ ${QL_URL_PORT} && ${QL_client_id} && ${QL_client_secret} ]]; then
                QL_Version=$(def_ql_version open)
                if [[ ${QL_Version} ]]; then
                    echo -e "${emoji_MSG} 目标青龙版本：v${QL_Version}\n"
                    get_token open
                    if [[ ${token} ]]; then
                        ckck_program
                    else
                        echo -e "${emoji_UNKNOW} 未获取目标青龙的 token，请检查 QL_client_id 和 QL_client_secret 变量后重试！\n"
                    fi
                else
                    echo -e "${emoji_UNKNOW} 未检测到目标青龙版本，请检查 QL_URL_PORT 后重试！\n"
                fi
            else
                [[ ! ${QL_URL_PORT} ]] && echo -e "${emoji_UNKNOW} 未填写 QL_URL_PORT 变量，请检查后重试！\n"
                [[ ! ${QL_client_id} ]] && echo -e "${emoji_UNKNOW} 未填写 QL_client_id 变量，请检查后重试！\n"
                [[ ! ${QL_client_secret} ]] && echo -e "${emoji_UNKNOW} 未填写 QL_client_secret 变量，请检查后重试！\n"
            fi
            ;;
        1)
            ck_api_type="open"
            wskey_api_type="open"
            if [[ ${QL_URL_PORT} && ${QL_client_id} && ${QL_client_secret} ]]; then
                QL_Version=$(def_ql_version open)
                if [[ ${QL_Version} ]]; then
                    echo -e "${emoji_MSG} 目标青龙版本：v${QL_Version}\n"
                    get_token open
                    if [[ ${token} ]]; then
                        ckck_program
                    else
                        echo -e "${emoji_UNKNOW} 未获取目标青龙的 token，请检查 QL_client_id 和 QL_client_secret 变量后重试！\n"
                    fi
                else
                    echo -e "${emoji_UNKNOW} 未检测到目标青龙版本，请检查 QL_URL_PORT 后重试！\n"
                fi
            else
                [[ ! ${QL_URL_PORT} ]] && echo -e "${emoji_UNKNOW} 未填写 QL_URL_PORT 变量，请检查后重试！\n"
                [[ ! ${QL_client_id} ]] && echo -e "${emoji_UNKNOW} 未填写 QL_client_id 变量，请检查后重试！\n"
                [[ ! ${QL_client_secret} ]] && echo -e "${emoji_UNKNOW} 未填写 QL_client_secret 变量，请检查后重试！\n"
            fi
            ;;
        *)
            ck_api_type="closure"
            wskey_api_type="closure"
            ckck_program
            ;;
    esac
}

main "$ckck_mode"
