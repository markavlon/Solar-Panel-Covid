%YPOLOGISMOS ARITHMOU PANEL KAI ISXYOS GIA TH DOSMENH STEGH DEDOMENOU OTI
%A)EXOUME MONO,POLY,RIBBON
%B)DOKIMAZOUME 2 PROSANATOLISMOYS
%C)H LEITOURGIA "VASH" EINAI YPO KATASKEYH KAI KOSTIZEI POLLA $... (SOON?)

%% USER INPUT
message1='Geia , thes mono,poly h ribbon [mono/poly/ribbon]\n';
kind=input(message1,"s");
message2='Thes ta panel na mpoun se seires h se mia megalh vash? [seira/vash]\n';
seira_vash=input(message2,"s");
message3='Thes h megalh diastash twn panel na einai pros borra-noto h anatolh-dysh? [BN/AD]\n';
panel_orientation=input(message3,"s");


[output1,output2]=geometry_calculations(kind,seira_vash,panel_orientation);

if output1(1)~=0 && output2(1)~="f" && ( any(strfind(output2,'BN')) || any(strfind(output2,'AD'))) && any(strfind(output2,'seira'))

    fprintf('Telika gia ton syndyasmo %s ,exoume %g panel kai %g W synolikh isxy\n',output2,output1(1),output1(2));    
else
      if any(strfind(output2,'vash')) && (any(strfind(output2,'BN')) || any(strfind(output2,'AD')))
         fprintf('<strong>H leitourgia vash apaitei $ gia na ylopoihthei. Please donate!</strong>\n')
      else
            fprintf('<strong> Yparxei sovaro thema katanohshs ths ellhnikhs (greeklish) grammateias</strong>.\n');
      end
end 


%% DIEREYNHSH KAI GIA TA 6 SENARIA
[np1,k1]=geometry_calculations('mono','seira','BN');
[np2,k2]=geometry_calculations('mono','seira','AD');
[np3,k3]=geometry_calculations('poly','seira','BN');
[np4,k4]=geometry_calculations('poly','seira','AD');
[np5,k5]=geometry_calculations('ribbon','seira','BN');
[np6,k6]=geometry_calculations('ribbon','seira','AD');

a_npanels=[np1(1),np2(1),np3(1),np4(1),np5(1),np6(1)];
a_power=[np1(2),np2(2),np3(2),np4(2),np5(2),np6(2)];
a_kind=[k1,' ',k2,' ',' ',k3,' ',k4,' ',k5,' ',k6];

max_npanels=max(a_npanels);
max_npanels_index=find(a_npanels==max_npanels);

max_power=max(a_power);
max_power_index=find(a_power==max_power);


if max_npanels_index==1
    k_tempn=k1;
elseif max_npanels_index==2
    k_tempn=k2;
elseif max_npanels_index==3
    k_tempn=k3;
elseif max_npanels_index==4
    k_tempn=k4;
elseif max_npanels_index==5
    k_tempn=k5;
else
    k_tempn=k6;
end

if max_power_index==1
    k_tempp=k1;
elseif max_power_index==2
    k_tempp=k2;
elseif max_power_index==3
    k_tempp=k3;
elseif max_power_index==4
    k_tempp=k4;
elseif max_power_index==5
    k_tempp=k5;
else
    k_tempp=k6;
end


fprintf('Me vash ton <strong> ARITHMO TWN PANEL </strong> to kalytero senario einai to <strong> %s pou dinei %g panel </strong>\n',k_tempn,max_npanels);
fprintf('Me vash th <strong> MEGISTH ISXY </strong> to kalytero senario einai to <strong> %s pou dinei %g W </strong>\n',k_tempp,max_power);
