#!/usr/bin/perl -w

use IO::Socket;
use IO::Select;
use POSIX;
#use POSIX qw(strftime);

my $listen_port=8732;
my $ServVersion = "0.05.2";

my $logfile = strftime "%Y-%m-%d", localtime;

my $SEAserver = IO::Socket::INET->new(LocalPort => $listen_port,
				      Listen	=> 10)
or die "Can't create TCP server on port $listen_port: $!\n";

my $MainSelect = IO::Select->new($SEAserver);
my $to_loop = 1;

my %SEAUsers;
# Хэш сокет -> ID
my %Sock2ID;
my $SEAUsersP=\%SEAUsers;

$SIG{INT} = \&tsktsk;

$SEAserver->autoflush(1);
STDOUT->autoflush(1);



open(LGFILE, ">>_serverlog/$logfile.txt") or die "Cannot create log file";

print  "\n\n\n              #######################################################\n";
print  "	      ##                                                   ##\n";
print  "	      ##   PERL SEA SERVER v. $ServVersion STARTED SUCCESFULLY   ##\n";
print  "	      ##                                                   ##\n";
print  "	      #######################################################\n\n\n";


while($to_loop)
{
# Get a list of sockets that are ready to talk to us.
        #
        #my ($ReadySocket, $ReadySocketO) = IO::Select->select($MainSelect, $MainSelect, undef, undef);
        foreach my $s ($MainSelect->can_read(1)) {
            
            # Is it a new connection?
            #
            if($s == $SEAserver) {
            
                # Accept the connection and add it to our readable list.
                # Generate internal descriptor
                                
                my ($new_sock, $other_end) = $SEAserver->accept; # 

                $MainSelect->add($new_sock) if $new_sock;
                print  "NewSock: $new_sock\n";
				prntscr("MainLoop", "MESSAGE", "NewSock: $new_sock");
		
				# Сгенерировать ID
				# Заполнить хэши %Sock2ID и %SEAUsers;
				my $new_id = GenID();
				$Sock2ID{$new_sock}=$new_id;
				my ($port, $iaddr) = unpack_sockaddr_in($other_end);
				my $client_ip = inet_ntoa($iaddr);
				
				if($new_id>0){
					$SEAUsers{$new_id}->{"IP"}= $client_ip;
				}else{
					print  "New ID is sub zero\n";
					prntscr("MainLoop", "New ID is sub zero. Disconnect. ID:", $new_id);
					Disconnect_SEA_Client($s);
					next;
				}
		
            } else {  # It's an established connection
						prntscr("MainLoop", "MESSAGE", "Established Socket $s");
						GetPack($s);
			}
        }

    foreach my $sout ($MainSelect->can_write(1)){
	    if(exists($Sock2ID{$sout}) && exists($SEAUsers{$Sock2ID{$sout}})){
			if (defined($SEAUsers{$Sock2ID{$sout}}->{"OutBuffer"})){
				if(length($SEAUsers{$Sock2ID{$sout}}->{"OutBuffer"})>0){
					my $outcnt = $sout->send($SEAUsers{$Sock2ID{$sout}}->{"OutBuffer"}, 0);
					if(defined $outcnt){
						if($outcnt>0){
							$SEAUsers{$Sock2ID{$sout}}->{"OutBuffer"}=substr($SEAUsers{$Sock2ID{$sout}}->{"OutBuffer"}, $outcnt);
						}else{
							print  "Cannot send ".$SEAUsers{$Sock2ID{$sout}}->{"OutBuffer"}."\n";
						}
					}
					#print MegaHash($SEAUsersP);
				}
			}else{next;}
	    }else{next;}
	}
}

sub GenID
{
    my $ID_to_generate = -1;
    my $i;

    for($i=1; $i<=2000; $i++){
	# Перебираем по очереди ID от 1 до 2000
		if(not(exists $SEAUsers{$i})){
		# Нашли ID, которого ещё нет в %SEAUsers
			$ID_to_generate = $i;
			prntscr("GenID", "ID:", $ID_to_generate);
			last;
		}else{
			print "ID: $i already exists\n";
		}
    }
    return $ID_to_generate;
}

sub GetPack
{
    my $socket = shift  ;
    my $tmpbuffer = ''  ;
    my $bytes_read = 0	;
    
    # Надо забрать всё, что пришло
    # А затем уже разбивать на команды

	prntscr("GetPack", "MESSAGE:", "Getting Data From Input Stream");

    my $CntFromSocket = $socket->recv($tmpbuffer,POSIX::BUFSIZ,0);
	
    if(defined $Sock2ID{$socket}){
	
		if(defined($CntFromSocket) && length($tmpbuffer)){
			
			if(defined($SEAUsers{$Sock2ID{$socket}})){
				
				$SEAUsers{$Sock2ID{$socket}}->{"InBuffer"}.=$tmpbuffer;
				CheckBuffer($Sock2ID{$socket});
			}else{
				
				Disconnect_SEA_Client($socket);
				prntscr("GetPack", "MESSAGE:", "Undefined value SEAUsers{Sock2ID{socket}}");
			}
		}else{
			
			Disconnect_SEA_Client($socket);
			prntscr("GetPack", "MESSAGE:", "Client disconnected... (by other side). Socket=" . $socket);
		}
    }else{
	    
		Disconnect_SEA_Client($socket);
		prntscr("GetPack", "MESSAGE:", "Socket not found in Sock2ID. Client disconnected...");
		if(defined $socket){
			prntscr("GetPack", "Socket:", $socket);
		}else{
			prntscr("GetPack", "Socket:", "Undefined");
		}
    }
}

sub CheckBuffer
{
    # Целочисленный идентификатор клиента
	my $ClientID = shift;
	
	# Существует ли значение $SEAUsers{$ClientID} ?
    if(defined($SEAUsers{$ClientID})){
	
		# Считаем длину пакета согласно протоколу из второго и третьего байта
		my $paclen = unpack("n", substr($SEAUsers{$ClientID}->{"InBuffer"}, 1, 2));
		#print  "CheckBuffer(Sock2ID{socket});\n";
		prntscr("CheckBuffer", "res:", "CheckBuffer(Sock2ID{socket})");
		
		# Длина буфера без первых трёх байт длины
		my $strlen = length(substr($SEAUsers{$ClientID}->{"InBuffer"}, 3));
		#print  "paclen".substr($SEAUsers{$ClientID}->{"InBuffer"}, 1, 2)."\n";
    
		
		prntscr("CheckBuffer", "paclen:", $paclen);
		prntscr("CheckBuffer", "strlen:", $strlen);
		#print  "Inbuffer: ".$SEAUsers{$ClientID}->{"InBuffer"}."\n";
    
		# Если длина буфера больше длины пакета (пришёл не один пакет)
		if(($strlen)>=$paclen){
			# Передаём ID клиента и пакет без остатков на основании длины по протоколу
			RunCommandFrom($ClientID, substr($SEAUsers{$ClientID}->{"InBuffer"}, 3, $paclen));
		}
    }
    else{
		print  "CheckBuffer: THIS ID DOES NOT EXIST!\n";
		my %ID2Sock = reverse %Sock2ID;
		Disconnect_SEA_Client($ID2Sock{$ClientID});
    }
}

sub Disconnect_SEA_Client
{
    my $socket = shift              	;
	if(defined $socket){
		if(defined $Sock2ID{$socket}){
		
			if(defined $SEAUsers{$Sock2ID{$socket}}){
			
				delete($SEAUsers{$Sock2ID{$socket}});
				print  "Deleting SEA User with ID=$Sock2ID{$socket}\n";
			}
	
			SendAllDel($Sock2ID{$socket})	;
			delete($Sock2ID{$socket})	;
		}
    
		$MainSelect->remove($socket)    	;
		close($socket);
    #$socket->close                 	;
    #$socket->shutdown(0);
	}else{
		prntscr("Disconnect_SEA_Client", "ERROR", "Undefined socket when try del it");
		print "Undefined socket error! \n";
	}
}

sub RunCommandFrom
{
   my ($locID, $str) = @_;
   my $SEAcommand = ord(substr($str, 0, 1));
   my $package = substr($str, 1);

   prntscr("RunCommandFrom", "mypack", $str);
   prntscr("RunCommandFrom", "ID", $locID);

	if($SEAcommand == 1){
		
		GetUserComp($locID, $package); 
	
	}elsif($SEAcommand == 2){
	
		SendMessage($locID, $package); 
   
	}elsif($SEAcommand == 3){
	
		$SEAUsers{$locID}->{"OutBuffer"}.="\x05";
   
	}elsif($SEAcommand == 4){
	
		GetUserInfo($locID, $package);
   
	}elsif($SEAcommand == 5){
	
		SendUserInfo($locID, $package); 
	
	}elsif($SEAcommand == 7 || $SEAcommand==8){
	
		ChatRoutine($locID, $package, $SEAcommand);
   
	}elsif($SEAcommand == 10){
	
		Ignore($locID, $package);
	
	}else{
	
	my $notice = "           __________________________________________________\n";
	   $notice .= "          |             Сервер не поддерживает данную команду            |\n";
	   $notice .= "          |             Команда, ";
	   $notice .= "посланная Вашим клиентом: $SEAcommand            |\n";
	   $notice .= "          |                               ---------------------                                            |\n";
	   $notice .= "          |             Unknown command!                                                  |\n";
	   $notice .= "          |             Your client sent next command: $SEAcommand                             |\n";
	   $notice .= "          ___________________________________________________";
	$SEAUsers{$locID}->{"OutBuffer"}.="\x04".pack("n", $locID)."\x01\x00\x00";
	$SEAUsers{$locID}->{"OutBuffer"}.=pack("n", length($notice)-1).$notice;
		
	}
	
	Fin($locID);
}

sub printMegaHash
{
    my $rHoH = shift;
    my $k1;
    my $k2;
    print  "\n##############>>> print ING MEGA HASH <<<##############\n";
    for $k1 ( sort keys %$rHoH )
    {
        print  "k1: $k1\n";
        for $k2 ( keys %{$rHoH->{ $k1 }} )
	{
            print  "k2: $k2 $rHoH->{ $k1 }{ $k2 }\n";
        }
    }
    print  "##############>>> print ING MEGA HASH <<<##############\n\n";
}

sub GetUserComp
{
    my ($fromID, $str)	= @_;

	prntscr("GetUserComp", "MESSAGE:", "Get Usercomp...");
	
    if(exists $SEAUsers{$fromID})
    {
	my $UserNameLen 	= ord(substr($str, 0, 1));
	my $UserName 	= substr($str, 1, $UserNameLen);
	my $CompNameLen 	= ord(substr($str, $UserNameLen+1, 1));
	my $CompName 	= substr($str, $UserNameLen+2, $CompNameLen);
	
		prntscr("GetUserComp", "UserName", $UserName);
		prntscr("GetUserComp", "CompName", $CompName);
	
	$SEAUsers{$fromID}->{"User"}=$UserName;
	$SEAUsers{$fromID}->{"Comp"}=$CompName;
	SendAllAdd($fromID, $UserName, $CompName);    
	my %ID2Sock = reverse %Sock2ID;
	SendUserlist($ID2Sock{$fromID});

    }
    else
    {

		prntscr("GetUserComp", "MESSAGE:", "THIS ID DOES NOT EXIST! $fromID");
		my %ID2Sock = reverse %Sock2ID;
		Disconnect_SEA_Client($ID2Sock{$fromID});
    }
}

sub SendMessage
{
    my ($fromID, $str) = @_;
    my $toID = unpack("n", substr($str, 0, 2));
    my $message = substr($str, 6);
	
    if($toID>0){

		prntscr("SendMessage", "fromID", $fromID);
		prntscr("SendMessage", "toID", $toID);
		prntscr("SendMessage", "Message", $message);
		#print  "\x04".pack("n", $fromID)."\x01\x00\x00".pack("n", length($message)).$message."\n";
		$SEAUsers{$toID}->{"OutBuffer"}.="\x04".pack("n", $fromID)."\x01\x00\x00";
		$SEAUsers{$toID}->{"OutBuffer"}.=pack("n", length($message)).$message."\x00";
		#print  "It's outbuffer: ".$SEAUsers{$toID}->{"OutBuffer"}."\n";
	
    }elsif($toID==0){
	
		prntscr("SendMessage", "Sending to All...", "$message");
		while(($ID, $UserPoint) = each(%SEAUsers)){
		
			$UserPoint->{"OutBuffer"}.="\x04".pack("n", $fromID)."\x00\x00\x00";
			$UserPoint->{"OutBuffer"}.=pack("n", length($message)).$message."\x00";
			
			prntscr("SendMessage", "toID: $ID", "message");
		}
		
		prntscr("SendMessage", "toAll", "Sending message to All complete");

    }
}

sub GetUserInfo
{
    my ($fromID, $str) = @_;
	
	prntscr("GetUserInfo", "begin:", "Get'n Userinfo...");
	
    my ($Faculty, $Room, $InfoLen) = unpack("A1 A5 A1", $str);
    $InfoLen = ord($InfoLen);
    my $Info = '';
    if($InfoLen>0)
    {
	$Info = substr($str, 7, $InfoLen);	
    }
    my $Vers = ord(substr($str, 7+$InfoLen, 1));
    #print  "Version=$Vers\n";
	prntscr("GetUserInfo", "Version:", $Vers);
    if(defined $SEAUsers{$fromID})
    {
	$SEAUsers{$fromID}->{"Faculty"}	= $Faculty;
	$SEAUsers{$fromID}->{"Room"}	= $Room;
	$SEAUsers{$fromID}->{"Info"}	= $Info;
	$SEAUsers{$fromID}->{"Version"}	= $Vers;

    }
    else
    {
	print  "Socket with ID $fromID not found. Client will be delete now!\n";
	my %ID2Sock = reverse %Sock2ID;
	Disconnect_SEA_Client($ID2Sock{$ID});
    }
}

sub SendUserlist
{
    my $socket  = shift;
    my $toID	= $Sock2ID{$socket};
    my $IP	= $SEAUsers{$toID}->{"IP"};
    my $sendstr = "\x01".pack("n", $toID).chr(length($IP)).$IP;
    my $usrlst  = '';
    my ($ID, $UserPoint);
    my ($usr, $comp);
    my $UserCnt = 0;
	
	prntscr("SendUserlist", "MESSAGE", "Sending user list...");
	
    while(($ID, $UserPoint) = each(%SEAUsers)){
	
		$usr	= $UserPoint->{"User"};
		$comp	= $UserPoint->{"Comp"};
	
		if(defined($ID) && defined($usr)&& defined($comp)){
	    
			$usrlst.= pack("n", $ID).chr(length($usr)).$usr.chr(length($comp)).$comp;
			$UserCnt++;
		
		}else{
		
			my %ID2Sock = reverse %Sock2ID;
			Disconnect_SEA_Client($ID2Sock{$ID});
		}
    }
    
	$sendstr.=pack("n", $UserCnt).$usrlst."\x00\x00";
	
    print  "Send Userlist ==> $sendstr\n";
	prntscr("SendUserlist", "usrlst", $usrlst);
	
    $SEAUsers{$toID}->{"OutBuffer"}.=$sendstr;
}

sub Fin
{
    my $fromID = shift;
    
	if(exists $SEAUsers{$fromID}){
	
		my $paclen = unpack("n", substr($SEAUsers{$fromID}->{"InBuffer"}, 1, 2));
		my $buflen = length($SEAUsers{$fromID}->{"InBuffer"})-3;
	
		prntscr("Fin", "MESSAGE", "Running FIN...");
	
		# Вырезаем из входного буфера обработанные данные
		if($paclen<=$buflen){
	    
			prntscr("Fin", "Package Length", $paclen);
			prntscr("Fin", "Buffer Length", $buflen);
		
			unless($paclen==$buflen){
			
				$SEAUsers{$fromID}->{"InBuffer"} = substr($SEAUsers{$fromID}->{"InBuffer"}, $paclen+3);
			}else{
			
				$SEAUsers{$fromID}->{"InBuffer"}='';
			}
	    
			if(length($SEAUsers{$fromID}->{"InBuffer"})>3){
				
				CheckBuffer($fromID);
			}
		
		}else{
	    
			print  "Not enough data in buffer:\n";
			prntscr("Fin", "MESSAGE", "Not enough data in a buffer");
			prntscr("Fin", "Package Length", $paclen);
			prntscr("Fin", "Buffer Length", $buflen);
		}
		prntscr("Fin", "MESSAGE", "FINISH OPERATE WITH PREVIOUS COMMAND ------------------------------------>");
    
	}else{
	
		print  "Fin: THIS ID DOES NOT EXIST!\n";
		prntscr("Fin", "ERROR", "ID $fromID DOES NOT EXIST IN SEAUsers");
		my %ID2Sock = reverse %Sock2ID;
		Disconnect_SEA_Client($ID2Sock{$fromID});
    }
}

# When New User Connected Send All ADDUSER
sub SendAllAdd
{
    my ($locID, $user, $comp) = @_;
    my ($ID, $UserPoint);
	
    while(($ID, $UserPoint) = each(%SEAUsers)){
	
		if($ID == $locID){next;} # Клиенту с $locID не посылаем себя же на добавление
	
		$UserPoint->{"OutBuffer"}.="\x02".pack("n", $locID);
		$UserPoint->{"OutBuffer"}.=chr(length($user)).$user;
		$UserPoint->{"OutBuffer"}.=chr(length($comp)).$comp;
    }
}

# When User Disconnected Send All DELUSER
sub SendAllDel
{
    my $locID = shift;
    
	while(($ID, $UserPoint) = each(%SEAUsers)){
	
		if(defined($ID)&&($ID ne "")){
	    
			if($ID == $locID){next;}
			$UserPoint->{"OutBuffer"}.="\x03".pack("n", $locID);
		}
    }
}

sub prntscr
{
    my ($fname, $parname, $par) = @_;
	my $now_string = strftime "%H:%M:%S", localtime;
	
    print  LGFILE "[$now_string] Function: $fname, $parname -> $par\n";
	#print "[$now_string]-> Function: $fname, Parameter->$parname = $par\n";
}

sub ipexists
{
	my $ip = shift;
	my $my_result = 0;
	#while(($ID, $UserPoint) = each(%SEAUsers))
    	#{
#		if($UserPoint->{"IP"} eq $ip)
#		{
#			$my_result = 1;
#			last;
#		}
#    	}
    	return $my_result;
}

sub SendUserInfo
{
    my ($fromID, $infoID) = @_;
    $infoID = unpack("n", $infoID);

	prntscr("SendUserInfo", "MESSAGE", "Sending UserInfo...");
	
    # Информация о пользователе
	# служебная 6, факультет, комната
	my 	$info  = "\x06" . $SEAUsers{$infoID}->{"Faculty"} . $SEAUsers{$infoID}->{"Room"};
	# количество пробелов 5 - длина номера комнаты
		$info .= " "x(5-length($SEAUsers{$infoID}->{"Room"}));
	# длина инфо в одном байте и инфо
		$info .= chr(length($SEAUsers{$infoID}->{"Info"})) . $SEAUsers{$infoID}->{"Info"};
	# версия клиента в одном байте и один байт длины IP-адреса
		$info .= chr($SEAUsers{$infoID}->{"Version"}) . chr(length($SEAUsers{$infoID}->{"IP"}));
	# IP-адрес
		$info .= $SEAUsers{$infoID}->{"IP"};
	
    prntscr("SendUserInfo", $fromID, $info);
	
    $SEAUsers{$fromID}->{"OutBuffer"}.= $info;

}

sub ChatRoutine
{
    my ($fromID, $str, $SEACommand) = @_;
    print  "Chat msg... \n";
    my $toID = unpack("n", substr($str, 0, 2));
    print  "From ID $fromID to ID $toID with SEACommand $SEACommand\n";
    $str = pack("n", $fromID).substr($str, 2);

    $SEAUsers{$toID}->{"OutBuffer"}.= chr($SEACommand).$str;
    prntscr("ChatRoutine", "str", $str);

}

sub Ignore
{
    my ($fromID, $str) = @_;
    my $toID = unpack("n", substr($str, 0, 2));

    $SEAUsers{$toID}->{"OutBuffer"}.= "\x0A".pack("n", $fromID);
    prntscr("Ignore", "Out", "\x10".pack("n", $fromID));

}

sub tsktsk {
    $SIG{INT} = \&tsktsk;           # See ``Writing A Signal Handler''
	print LGFILE "---------------- End Previous Session -----------------\n\n";
	close(LGFILE);
    die "\aThe long habit of living indisposeth us for dying.\n";
}