import subprocess

def get_gpu():
	hostname = subprocess.check_output("hostname", shell=True).decode('ascii').split('\n')[0]
	try:
		gpu_info = subprocess.check_output("lspci | grep -i nvidia | grep -i vga", shell=True)
		#gpu_lines = [line for line in gpu_info.decode("ascii").split('\n') if line.strip()]
		#num_gpus = len(gpu_lines)
		num_gpus = len(gpu_info.decode('utf-8').splitlines())
		print(f"Number of GPUs: {num_gpus} on computer: {hostname}")
		gpu_name = gpu_info.decode("ascii").split('[')[1].split(']')[0]
		print(gpu_name)
		return gpu_name
	except (subprocess.CalledProcessError, FileNotFoundError, UnicodeDecodeError):
		print(f'No GPUs detected on computer: {hostname}')

get_gpu()

quit()

def get_gpu():
    gpu_info = subprocess.check_output("nvidia-smi -L", shell=True)
    #print(gpu_info.decode("ascii"))
    gpu_name = gpu_info.decode("ascii").split(':')[1].split('(')[0]
    #print(gpu_name)
    return gpu_name
