# Zabbix Template: Speedtest

Monitoring internet bandwidth using speedtest and zabbix. The script uses `zabbix_sender` to send the values to a Zabbix Server. The interval is set via cron.

## Screenshots
### Gathered Data
![Latest Data](screenshots/data.png)

### Graphs
![Triggers](screenshots/graph-up-down.png)


## How to Use

1. Install ([ookla speedtest cli](https://www.speedtest.net/apps/cli))

	```bash
	curl -Lo /usr/bin/speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
	chmod +x /usr/bin/speedtest-cli
	```

1. Download `speedtest-zabbix.sh`

	```bash
	mkdir -p /etc/zabbix/scripts
	cd /etc/zabbix/scripts
	curl -LO https://raw.githubusercontent.com/sebastian13/zabbix-template-speedtest/master/scripts/speedtest-zabbix.sh
	chmod +x speedtest-zabbix.sh
	```

1. Create Cron

	```bash
	curl -Lo /etc/cron.d/speedtest-zabbix https://raw.githubusercontent.com/sebastian13/zabbix-template-speedtest/master/speedtest-zabbix.cron
	service cron reload
	```

1. Import the Template `zbx_template_speedtest.xml` to Zabbix and assign in to a server.

### Additional Resources

- [Manpage: Zabbix Sender](https://www.zabbix.com/documentation/current/manpages/zabbix_sender)
- [Usage: Speedtest-CLI](https://github.com/sivel/speedtest-cli)
