#Auto Restart by Leandro Rissa
#!/bin/bash
# script pra rodar novamente o server automático em caso de crash
echo "Iniciando o programa"
cd /home/otserv/Retro
mkdir -p logs
#configs necessárias para o Anti-rollback
ulimit -c unlimited
set -o pipefail
while true 		#repetir pra sempre
do
 	#roda o server e guarda o output ou qualquer erro no logs
	#PS: o arquivo antirollback_config deve estar na pasta do tfs	
	gdb --batch -return-child-result --command=antirollback_config --args ./otx 2>&1 | awk '{ print strftime("%F %T - "), $0; fflush(); }' | tee "data/logs/Logserv/$(date +"%F %H-%M-%S.log")"
	if [ $? -eq 0 ]; then							 
		echo "Exit code 0, aguardando 5 segundos..."	 #pra ser usado no backup do banco de dados
		sleep 5	#5 segundos						
	else											
		echo "Crash!! Reiniciando o servidor em 5 segundos (O arquivo de log está guardado na pasta logs)"
		echo "Se quiser encerrar o servidor, pressione CTRL + C..."		
		sleep 5										
	fi												
done;