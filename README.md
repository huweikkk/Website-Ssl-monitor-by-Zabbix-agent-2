# zabbix 批量监控站点证书过期时间
流程：通过Low-level discovery,批量监控站点的ssl证书过期时间，站点可以指定域名，特定端口，指定hots

1.参考：

https://www.zabbix.com/integrations/ssl
https://git.zabbix.com/projects/ZBX/repos/zabbix/browse/templates/app/certificate_agent2?at=release/7.2

2.需求:

zabbix 支持 Zabbix agent 2 .
Zabbix version: 7.2 and higher.

3.说明:

自动发现
Key：ssl.discovery

WebCertificate plugin

web.certificate.get[{$CERT.WEBSITE.HOSTNAME},{$CERT.WEBSITE.PORT},{$CERT.WEBSITE.IP}]

{$CERT.EXPIRY.WARN}	        证书过期时间，默认为7天

{$CERT.WEBSITE.HOSTNAME}	站点名称，默认不带https://，访问的时候自动转换，必填

{$CERT.WEBSITE.PORT}	    站点https端口，默认为443，非必填，

{$CERT.WEBSITE.IP}	        指定站点访问的IP，非必填，不填的时候使用公网解析IP

例如：

[root@gz7-zabbixserver etc]# /usr/local/zabbix/bin/zabbix_get -s 127.0.0.1 -k web.certificate.get[www.baidu.com,443,183.2.172.177]
{"x509":{"version":3,"serial_number":"4e4003a65eb681f87f4bd8eb","signature_algorithm":"SHA256-RSA","issuer":"CN=GlobalSign RSA OV SSL CA 2018,O=GlobalSign nv-sa,C=BE","not_before":{"value":"Jul 08 01:41:02 2024 GMT","timestamp":1720402862},"not_after":{"value":"Aug 09 01:41:01 2025 GMT","timestamp":1754703661},"subject":"CN=baidu.com,O=Beijing Baidu Netcom Science Technology Co.\\, Ltd,L=beijing,ST=beijing,C=CN","public_key_algorithm":"RSA","alternative_names":["baidu.com","baifubao.com","www.baidu.cn","www.baidu.com.cn","mct.y.nuomi.com","apollo.auto","dwz.cn","*.baidu.com","*.baifubao.com","*.baidustatic.com","*.bdstatic.com","*.bdimg.com","*.hao123.com","*.nuomi.com","*.chuanke.com","*.trustgo.com","*.bce.baidu.com","*.eyun.baidu.com","*.map.baidu.com","*.mbd.baidu.com","*.fanyi.baidu.com","*.baidubce.com","*.mipcdn.com","*.news.baidu.com","*.baidupcs.com","*.aipage.com","*.aipage.cn","*.bcehost.com","*.safe.baidu.com","*.im.baidu.com","*.baiducontent.com","*.dlnel.com","*.dlnel.org","*.dueros.baidu.com","*.su.baidu.com","*.91.com","*.hao123.baidu.com","*.apollo.auto","*.xueshu.baidu.com","*.bj.baidubce.com","*.gz.baidubce.com","*.smartapps.cn","*.bdtjrcv.com","*.hao222.com","*.haokan.com","*.pae.baidu.com","*.vd.bdstatic.com","*.cloud.baidu.com","click.hm.baidu.com","log.hm.baidu.com","cm.pos.baidu.com","wn.pos.baidu.com","update.pan.baidu.com"]},"result":{"value":"valid","message":"certificate verified successfully"},"sha1_fingerprint":"ef0fbe1302e2c4d489ba8fba88ef6f95dccf7be0","sha256_fingerprint":"9073ded9d993a934c29c5ec3c6afa7286d2f0f8848352f94d02035865d8568e2"}
格式化数据:
[root@gz7-zabbixserver etc]# /usr/local/zabbix/bin/zabbix_get -s 127.0.0.1 -k web.certificate.get[www.baidu.com,443,183.2.172.177]|jq '.x509.not_after.value'
"Aug 09 01:41:01 2025 GMT"
[root@gz7-zabbixserver etc]# /usr/local/zabbix/bin/zabbix_get -s 127.0.0.1 -k web.certificate.get[www.baidu.com,443,183.2.172.177]|jq '.x509.not_after.timestamp'
1754703661

4.使用流程

导入模版zbx_export_templates.xml

确认zabbix_agent2配置文件包含ssl-check.conf文件

/usr/local/zabbix/scripts/ssl_low_discovery.sh，可执行,如果是zabbix用户运行客户端，建议直接将zabbix整个文件夹使用zabbix用户权限

/usr/local/zabbix/scripts/https_check.txt 文件包含需要监控的站点