import logging 
import socketserver 
import socket 
import requests 

class SyslogUDPHandler(socketserver.BaseRequestHandler):

    filters = ["isSystemEvents","isFirewallEvents","isDNSEvents","isDHCPEvents","isPPPEvents","isCaptivePortalEvents","isVPNEvents","isGatewayMonitorEvents","isRouting","isLoadBalancer","isWirelessEvents"]
    events = ["syslogd:","Firewall","DNS","DHCP","PPP","Captive","VPN","Gateway","Routing","Balancer","Wirelless"]
    def post(self,data):
        self.server_url = 'http://192.168.1.14:9998/logs'
        try :
            req = requests.post(self.server_url,data=data)
            #print(data)
        except Exception as e :
            print(e)
    def handle(self):
        try:
            description = bytes.decode(self.request[0].strip(), encoding="utf-8")
        except UnicodeError:
            description = 'unkown packet contents'
        tabdescription = ['unkown packet contents']
        if description != 'unkown packet contents':
            
            tabdescription = description[1:].split(" ")
            code = tabdescription[0].split('>')[0]
            month = tabdescription[0].split('>')[1]
            del tabdescription[0]
            tabdescription.insert(0,code)
            tabdescription.insert(1,month)
            for i,a in enumerate(tabdescription):
                if a == "" :
                       del tabdescription[i]
           
        
        
        # socket = self.request[1]
        #print("%s : " % self.client_address[0], str(data))
        data = {"address":str(self.client_address[0]),"description":str(tabdescription)}
        if "WAN_DHCP" not in description and "icmp"  not in description:
            datatype = "unknown"
            for i,event in enumerate(self.events) :
                if event == tabdescription[4] :
                    datatype = self.filters[i]
                    break
            data["type"] = datatype
            self.post(data)
        logging.info(str(data))

#Syslog server
class SyslogServer():

    def __init__(self,ip="0.0.0.0",port=514):
        self.ip = ip 
        self.port = port
        self.logfile = "routermonitor_logs.log"
    def start(self):
        logging.basicConfig(level=logging.INFO, format='%(message)s', datefmt='',filename=self.logfile, filemode='a')
        print('Syslog server running on port :',self.port)
        try:
            server = socketserver.UDPServer((self.ip, self.port), SyslogUDPHandler)
            server.serve_forever(poll_interval=0.5)
        except (IOError, SystemExit):
            raise
            print('Error')
        except KeyboardInterrupt:
            print("Crtl+C Pressed. Shutting down.")

syslogserver = SyslogServer()
syslogserver.start()
