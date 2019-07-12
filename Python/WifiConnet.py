import pywifi
import sys
import time
import subprocess
import os
import telnetlib
import socket

from pywifi import *
#from telnetlib import Telnet

RELAY_APP_IP_ADDRESS = '127.0.0.1'
RELAY_APP_TCP_PORT = 33333

host='192.168.0.1'
Telnet_Username='root'
Telnet_Passward=''
finish='Login incorrect'

cat_fail_command='cat /app/private/FacAgingRet'

MAC_ADDDRESS = "OBSBOT_Tail_d51c9a"
portNum = '7';

def wifi_connect_status():
	wifi=pywifi.PyWiFi()
	ifaces=wifi.interfaces()[0]
	print(ifaces.name())
	profile = pywifi.Profile()
	profile.ssid=MAC_ADDDRESS
	#ifaces.remove_all_network_profiles() 
	tmp_profile=ifaces.add_network_profile(profile)
	ifaces.connect(tmp_profile)
	time.sleep(10)
	if ifaces.status()==const.IFACE_CONNECTED: 
		print("连接成功，端口", profile.ssid, portNum) 
	else: 
		print("连接失败，端口", profile.ssid, portNum)
	#ifaces.disconnect()

def do_telnet():
	tn=telnetlib.Telnet(host, port=23, timeout=10)
	#tn.set_debuglevel(2)  
	
	#输入登录用户名 
	tn.read_until(b"(none) login:", timeout=10)  
	tn.write(Telnet_Username.encode('ascii')+b'\n') 
	
	# 输入登录密码  
	tn.read_until(b"Password:", timeout=10)  
	tn.write(Telnet_Passward.encode('ascii')+b'\n')
	time.sleep(15)
	
	login_result = tn.read_very_eager().decode('ascii')
	print(login_result)
	if 'Login incorrect' not in login_result:
		print('登录成功')
	else:
		print('登录失败，用户名或密码错误')
	
	# 输入命令
	tn.write(cat_fail_command.encode('ascii')+b'\n') 
	time.sleep(4)
	command_result = tn.read_very_eager().decode('ascii')	
	print(command_result)
	
	if 'SUCCESS' in command_result:
		print("老化成功，将关机冷却一段时间20min")
		tn.close()
		return True
	else:
		tn.close()
		print("老化失败")
		return False
	
	

	
def cameraPowerBtnPress(tcpSocket, portNum):
	tcpClient.sendall(portNum.encode('ascii'))
	
if __name__=='__main__':
	while True: 
		tcpClient = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		tcpClient.connect((RELAY_APP_IP_ADDRESS, RELAY_APP_TCP_PORT))
		#power on
		cameraPowerBtnPress(tcpClient, portNum)
		#老化完成后的连接
		print("正在等待老化完成，接近60min.....")
		time.sleep(3600)
			
		wifi_connect_status()
		ret = do_telnet()
		if (ret == True):
			time.sleep(1200)	
			cameraPowerBtnPress(tcpClient, portNum)
		else:
			#发送电子邮件
			print("end")
			tcpClient.close()
			break;
		
		tcpClient.close()
		