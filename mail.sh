#!/bin/sh

# 送信先メールアドレスの指定
MAILADDR='r-ogata@bbtower.co.jp'


# IP アドレスからホスト名を検索
HOSTNAME=`dig -x $1 | grep -v \; | grep PTR | awk '{print $5}'`

# IP アドレスから国名を検索
COUNTRY=`whois -h whois.apnic.net -v $1 | grep country | uniq | head -1 | awk '{print $2}'`

# dscr を取得
DSCR=`whois -h whois.apnic.net 211.14.2.129 | grep descr | awk -F ":         " '{print $2 ,":"}' | tr -d '\n' | sed -e "s/:$//"`

# netname を取得
NETNAME=`whois -h whois.apnic.net 211.14.2.129 | grep netname | awk -F ":       " '{print $2 , ":"}' | tr -d '\n' | sed -e "s/:$//"`


if [ -n "$HOSTNAME" ]; then
        # 国名が判別できた場合の処理
        SUBJECT=$HOSTNAME
else
        # 国名が判別できなかった場合の処理
        HOSTNAME=""
        COUNTRY=""
        SUBJECT=$1
fi


# メールの送信
cat <<EOL | /bin/mail -s "HTTP BLACKLIST $SUBJECT" $MAILADDR
mod_evasive HTTP Blacklisted:
  IP Address : $1
  Host Name  : $HOSTNAME
  Country    : $COUNTRY
  Descr      :$DSCR
  Netname    :$NETNAME
EOL
