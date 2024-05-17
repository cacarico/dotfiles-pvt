import nmap
import sys

def perform_scan(target_ip):
    nm = nmap.PortScanner()
    arguments = '-p- --min-rate 1000 -sV -sC -oN nmap.txt'
    nm.scan(hosts=target_ip, arguments=arguments)
    if nm[target_ip].state() == 'up':
        print("Scan results for:", target_ip)
        for host in nm.all_hosts():
            print("Host:", host)
            for proto in nm[host].all_protocols():
                print("Protocol:", proto)
                ports = nm[host][proto].keys()
                for port in ports:
                    print("Port:", port, "State:", nm[host][proto][port]['state'], "Service:", nm[host][proto][port]['name'])
    else:
        print("Host", target_ip, "is down.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python scan.py <target_ip>")
        sys.exit(1)

    target_ip = sys.argv[1]
    perform_scan(target_ip)
