  
%1)Prepei analoga me thn perioxh ths egkatastashs na allakseis b,z kai oles
%tis skies

%2)An thes diadromo mprosta apo to thermosifwna kai oxi apo pisw tou,
% grapse -diadromos sth metavlhth y_diathesimo_d.

function [f1,f2]=geometry_calculations(kind,seira_vash,panel_orientation)

%parametroi hliakhs gewmetrias
    b=21.896; %deg
    z=29.628; %deg

%skies dosmenwn empodiwn
    skia_plaina_stithaia=1.353;
    skia_mprostino_stithaio=2.7368;

    diadromos=0.60;

    d_skias_klim=1.7062;
    l_skias_klim=3;

    d_skias_therm=1.9621;
    l_skias_therm=2.49+0.96;

    phi_skias_klim=atand(d_skias_klim/l_skias_klim);
    phi_skias_therm=atand(d_skias_therm/l_skias_therm);

%parametroi diathesimou xwrou gia panels
    x_taratsas=16.3;
    y_taratsas=11;
    %kentrikos xwros
    x_diathesimo=x_taratsas-2*skia_plaina_stithaia;
    y_diathesimo_a=y_taratsas-3-diadromos-skia_mprostino_stithaio;
    y_diathesimo_d=y_taratsas-2.49-0.96-skia_mprostino_stithaio;
    y_diathesimo_k=y_taratsas-skia_mprostino_stithaio-diadromos;

%parametroi vasewn
    h_vashs_max=1.60;
%skia vashs
    skia_vashs_max=h_vashs_max/(tand(b));

%klish panel se deg
    a=30; 


%Mhkos platos isxys analoga me to eidos tou panel 

    if kind=="mono" && (seira_vash=="seira") && (panel_orientation=="BN" || panel_orientation=="AD")
        l=1.58;
        w=0.83;
        power=175;
        
    elseif kind=="poly" && (seira_vash=="seira") && (panel_orientation=="BN" || panel_orientation=="AD")
        l=1.69;
        w=0.99;
        power=225;
        
    elseif kind=="ribbon" && (seira_vash=="seira") && (panel_orientation=="BN" || panel_orientation=="AD")
        l=1.89;
        w=1.28;
        power=310;

    elseif seira_vash=="vash"
        f1=[0,0];
        f2=['vash',' ',panel_orientation];
        return
    else 
        
        f1=[0,0];
        f2=['false_arg','false_arg' ,'false_arg'];
        return
    end
    

    %PANEL SE SEIRA ME PROSANATOLISMO BN    
    
    if seira_vash=="seira" && panel_orientation=="BN"
        n1=fix(x_diathesimo/w);
        xam_mhkos=l*cosd(a);
        skia_panel=(sind(30)*l)/tand(b);

        % Initial guess
        initial_guess = [-1, 1];

        % Solve the system of equations
        param1=skia_panel;
        param2=z;
        solution = fsolve(@(vars) equations(vars,param1,param2), initial_guess);

        d_skias=solution(1);                %stis 2 thn meshmvrian (epilysh 2 mh grammikwn eksiswsewn)
        l_skias=solution(2);

        % Print the solution
        fprintf('H skia einai %g kata AD kai %g kata BN\n',d_skias,l_skias);

        

        fprintf('H prwth seira xwraei %g panel\n',n1);
        ya_temp=y_diathesimo_a-xam_mhkos-skia_panel;
        yd_temp=y_diathesimo_d-xam_mhkos-skia_panel;


        if max(ya_temp,yd_temp)>l_skias && max(ya_temp,yd_temp)>xam_mhkos+skia_panel      %an eimaste poly makria apo to na skiasoume ton thermosifwna
            n2=n1;
        else
            n2=0;
            n2a=0;
            n2d=0;
        %elegxos apo aristera meta thn prosthiki ths 1hs seiras
        
        if ya_temp<xam_mhkos
            fprintf('Den xwraei 2h seira me panel apo aristera\n') 
        else 
              %xwraei 2h seira aristera
            x_temp=5+diadromos-skia_plaina_stithaia;          %diathesimo mhkos kata x mprosta apo klimakostasio
            n2a=fix(x_temp/w);
            fprintf('H deyterh seira xwraei %g panel apo aristera\n',n2a)
            n2=n2+n2a;
        end
        
        %elegxos apo deksia meta thn prosthiki ths 2hs seiras

        if yd_temp<xam_mhkos+skia_panel
            fprintf('Den xwraei 2h seira me panel apo deksia\n')
        else 
                      %xwraei 2h seira deksia
            x_temp=4.40+2.29-skia_plaina_stithaia;                  %diathesimos xwros kata x apo deksia
            n2d=fix(x_temp/w);
            fprintf('H deyterh seira xwraei %g panel apo deksia\n',n2d)
            n2=n2+n2d;
        
        end

        %elegxos anamesa apo klimakostasio kai thermosifwna meta thn
        %prosthiki ths 1hs seiras
        y_anamesa=y_diathesimo_k-skia_panel-xam_mhkos;
        n2k=0;
        if y_anamesa>xam_mhkos+2.49+0.96
            x_temp=4.61;     
            n2k_temp=fix(x_temp/w);
            n2k=n2k+n2k_temp;
            n2=n2+n2k;
            fprintf('H deyterh seira xwraei %g panel sto kentro\n',n2k)
        elseif y_anamesa-xam_mhkos>0
            s=y_anamesa+0.6-xam_mhkos;
            l1=3-s ;                        %kommati skias  kata y logw klimakostasio
            l2=3.45-s;                      %kommati skias kata y logw thermosifwna
            
            if l1>0
                d1=tand(phi_skias_klim)*l1;      %kommati skias kata x logw klimakostasio
            else
                d1=0;
            end
            
            if l2>0
                d2=tand(phi_skias_therm)*l2;     %kommati skias kata x logw thermosifwna
            else
                d2=0;
            end
            
            x_temp=4.61-max(diadromos,d1)-max(d2,d_skias);
            n2k=n2k+fix(x_temp/w);
            n2=n2+n2k;
            fprintf('H deyterh seira xwraei %g panel sto kentro\n',n2k)
              %edw thelei elegxo skiwn apo klim kai th/s
            else 
            fprintf('H deyterh seira den xwraei panel sto kentro\n')
            
        end
            
        end 

        fprintf('H deyterh seira xwraei %g panel\n',n2)


                   %trith seira

        ya_temp1=ya_temp-xam_mhkos-skia_panel;
        yd_temp1=yd_temp-xam_mhkos-skia_panel;
            

        if max(ya_temp1,yd_temp1)>l_skias && max(ya_temp1,yd_temp1)>xam_mhkos+skia_panel     %an eimaste poly makria apo to na skiasoume ton thermosifwna
            n3=n2;
           
        else
            n3=0;
            n3a=0;
            n3d=0;
        %elegxos apo aristera meta thn prosthiki ths 2hs seiras
        
        if ya_temp1<xam_mhkos
            fprintf('Den xwraei 3h seira me panel apo aristera\n') 
        else 
            %xwraei 3h seira aristera
            x_temp=5+diadromos-skia_plaina_stithaia;          %diathesimo mhkos kata x mprosta apo klimakostasio
            n3a=fix(x_temp/w);
            fprintf('H trith seira xwraei %g panel apo aristera\n',n3a)
            n3=n3+n3a;
        end
        
        %elegxos apo deksia meta thn prosthiki ths 2hs seiras
    
        if yd_temp1<xam_mhkos+skia_panel
            fprintf('Den xwraei 3h seira me panel apo deksia\n')
        else 
            %xwraei 3h seira deksia
            x_temp=4.40+2.29-skia_plaina_stithaia;  %diathesimos xwros kata x apo deksia
            n3d=fix(x_temp/w);
            fprintf('H trith seira xwraei %g panel apo deksia\n',n3d)
            n3=n3+n3d;
        end

        %elegxos anamesa apo klimakostasio kai thermosifwna meta thn
        %prosthiki ths deyterhs seiras
        n3k=0;
        y_anamesa=y_diathesimo_k-2*(xam_mhkos+skia_panel);
        if y_anamesa>xam_mhkos+2.49+0.96
            x_temp=4.61;     
            n3k_temp=fix(x_temp/w);
            n3k=n3k+n3k_temp;
            n3=n3+n3k;
            fprintf('H trith seira xwraei %g panel sto kentro\n',n3k)
        elseif y_anamesa-xam_mhkos>0
            s=y_anamesa+0.6-xam_mhkos;
            l1=3-s;                         %kommati skias  kata y logw klimakostasio
            l2=3.45-s;                      %kommati skias kata y logw thermosifwna
            
            if l1>0
                d1=tand(phi_skias_klim)*l1;      %kommati skias kata x logw klimakostasio
            else
                d1=0;
            end
            if l2>0
                d2=tand(phi_skias_therm)*l2;     %kommati skias kata x logw thermosifwna
            else
                d2=0;
            end
            
            x_temp=4.61-max(diadromos,d1)-max(d2,d_skias);
            n3k=n3k+fix(x_temp/w);
            n3=n3+n3k;
            fprintf('H trith seira xwraei %g panel sto kentro\n',n3k)
              %edw thelei elegxo skiwn apo klim kai th/s
            else 
            fprintf('Den xwraei 3h seira me panel sto kentro\n')
        
            fprintf('H trith seira xwraei %g panel\n',n3)
        end 
        fprintf('H trith seira xwraei %g panel\n',n3)
        end

                %tetarth seira sto kentro 
        n4=0;
        y_anamesa=y_diathesimo_k-3*(xam_mhkos+skia_panel);
        x_anamesa=4.61-diadromos-d_skias;
        
        if y_anamesa>xam_mhkos+2.49+0.96   %na allaxtei pantou
        n4=fix(x_anamesa/w);
           fprintf('H tetarth seira xwraei %g panel sto kentro\n\n',n4)
        elseif y_anamesa-xam_mhkos>0
            s=y_anamesa+0.6-xam_mhkos;
            l1=3-s;                         %kommati skias  kata y logw klimakostasio
            l2=3.45-s;                      %kommati skias kata y logw thermosifwna
            
            if l1>0
                d1=tand(phi_skias_klim)*l1;      %kommati skias kata x logw klimakostasio
            else
                d1=0;
            end
            
            if l2>0
                d2=tand(phi_skias_therm)*l2;     %kommati skias kata x logw thermosifwna
            else
                d2=0;
            end

            
            x_temp=4.61-max(diadromos,d1)-max(d2,d_skias);
            n4=fix(x_temp/w);
            fprintf('H tetarth seira xwraei %g panel sto kentro\n\n',n4)
              %edw thelei elegxo skiwn apo klim kai th/s
            else 
            fprintf('H tetarth seira xwraei %g panel sto kentro\n\n',n4)
            
        end        
   end 
if seira_vash=="seira" && panel_orientation=="AD"
    n1=fix(x_diathesimo/l);
        xam_mhkos=w*cosd(a);
        skia_panel=(sind(30)*w)/tand(b);
        
        % Initial guess
        initial_guess = [-1, 1];

        % Solve the system of equations
        param1=skia_panel;
        param2=z;
        solution = fsolve(@(vars) equations(vars,param1,param2), initial_guess);

        % Print the solution
        d_skias=solution(1);
        l_skias=solution(2);
        fprintf('H skia einai %g kata AD kai %g kata BN\n',d_skias,l_skias);


        fprintf('H prwth seira xwraei %g panel\n',n1);

        ya_temp=y_diathesimo_a-xam_mhkos-skia_panel;
        yd_temp=y_diathesimo_d-xam_mhkos-skia_panel;
        
        if max(ya_temp,yd_temp)>l_skias && max(ya_temp,yd_temp)>xam_mhkos+skia_panel      %an eimaste poly makria apo to na skiasoume ton thermosifwna
            n2=n1;
            
        else
           n2a=0;
           n2d=0;
           n2=0;
        %elegxos apo aristera meta thn prosthiki ths 1hs seiras
        
        if ya_temp<xam_mhkos
            fprintf('Den xwraei 2h seira me panel apo aristera\n') 
        else 
            %xwraei 2h seira aristera
            x_temp=5+diadromos-skia_plaina_stithaia;          %diathesimo mhkos kata x mprosta apo klimakostasio
            n2a=fix(x_temp/l);
            n2=n2+n2a;
            fprintf('H deyterh seira xwraei %g panel apo aristera\n',n2a)
        end
        
        %elegxos apo deksia meta thn prosthiki ths 1hs seiras
    
        if yd_temp<xam_mhkos+skia_panel
            fprintf('Den xwraei 2h seira me panel apo deksia\n')
        else 
            %xwraei 2h seira deksia
            x_temp=4.40+2.29-skia_plaina_stithaia;  %diathesimos xwros kata x apo deksia
            n2d=fix(x_temp/l);
            n2=n2+n2d;
            fprintf('H deyterh seira xwraei %g panel apo deksia\n',n2d)
        
        
        end

        %elegxos anamesa apo klimakostasio kai thermosifwna meta thn
        %prosthiki ths 1hs seiras
        y_anamesa=y_diathesimo_k-skia_panel-xam_mhkos;
        n2k=0;
        if y_anamesa>xam_mhkos+2.49+0.96
            x_temp=4.61;     
            n2k_temp=fix(x_temp/l);
            n2k=n2k+n2k_temp;
            n2=n2+n2k;
            fprintf('H deyterh seira xwraei %g panel sto kentro\n',n2k)
        elseif y_anamesa-xam_mhkos>0
            s=y_anamesa+0.6-xam_mhkos;
            l1=3-s ;                        %kommati skias  kata y logw klimakostasio
            l2=3.45-s;                      %kommati skias kata y logw thermosifwna
            
            if l1>0
                d1=tand(phi_skias_klim)*l1;      %kommati skias kata x logw klimakostasio
            else 
                d1=0;
            end
            
            if l2>0
                d2=tand(phi_skias_therm)*l2;     %kommati skias kata x logw thermosifwna
            else
                d2=0;
            end
            
            x_temp=4.61-max(diadromos,d1)-max(d2,d_skias);
            n2k=n2k+fix(x_temp/l);
            n2=n2+n2k;
            fprintf('H deyterh seira xwraei %g panel sto kentro\n',n2k)
              %edw thelei elegxo skiwn apo klim kai th/s
            else 
            fprintf('H deyterh seira den xwraei panel sto kentro\n')
            
        end
            
        end 

        fprintf('H deyterh seira xwraei %g panel\n',n2)

                 %trith seira

        ya_temp1=ya_temp-xam_mhkos-skia_panel;
        yd_temp1=yd_temp-xam_mhkos-skia_panel;

        if max(ya_temp1,yd_temp1)>l_skias && max(ya_temp1,yd_temp1)>xam_mhkos+skia_panel     %an eimaste poly makria apo to na skiasoume ton thermosifwna
            n3=n2;
            
        else
            n3=0;
            n3a=0;
            n3d=0;
        %elegxos apo aristera meta thn prosthiki ths 2hs seiras
        
        if ya_temp1<xam_mhkos
            fprintf('Den xwraei 3h seira me panel apo aristera\n') 
        else 
            %xwraei 3h seira aristera
            x_temp=5+diadromos-skia_plaina_stithaia;          %diathesimo mhkos kata x mprosta apo klimakostasio
            n3a=fix(x_temp/l);
            fprintf('H trith seira xwraei %g panel apo aristera\n',n3a)
            n3=n3+n3a;
        end
        
        
        %elegxos apo deksia meta thn prosthiki ths 2hs seiras
    
        if yd_temp1<xam_mhkos+skia_panel
            fprintf('Den xwraei 3h seira me panel apo deksia\n')
        else 
            %xwraei 3h seira deksia
            x_temp=4.40+2.29-skia_plaina_stithaia;  %diathesimos xwros kata x apo deksia
            n3d=fix(x_temp/l);
            fprintf('H trith seira xwraei %g panel apo deksia\n',n3d)
            n3=n3+n3d;
        end

        %elegxos anamesa apo klimakostasio kai thermosifwna meta thn
        %prosthiki ths deyterhs seiras
        n3k=0;
        y_anamesa=y_diathesimo_k-2*(xam_mhkos+skia_panel);
        if y_anamesa>xam_mhkos+2.49+0.96
            x_temp=4.61;     
            n3k_temp=fix(x_temp/l);
            n3k=n3k+n3k_temp;
            n3=n3+n3k;
            fprintf('H trith seira xwrai %g panel sto kentro\n',n3k)
        elseif y_anamesa-xam_mhkos>0
            s=y_anamesa+0.6-xam_mhkos;
            l1=3-s;                         %kommati skias  kata y logw klimakostasio
            l2=3.45-s;                      %kommati skias kata y logw thermosifwna
           
            if l1>0
                d1=tand(phi_skias_klim)*l1;      %kommati skias kata x logw klimakostasio
            else 
                d1=0;
            end
            
            if l2>0
                d2=tand(phi_skias_therm)*l2;     %kommati skias kata x logw thermosifwna
            else
                d2=0;
            end
            
           x_temp=4.61-max(diadromos,d1)-max(d2,d_skias);
            n3k=n3k+fix(x_temp/l);
            n3=n3+n3k;
            fprintf('H trith seira xwraei %g panel sto kentro\n',n3k)
              %edw thelei elegxo skiwn apo klim kai th/s
            else 
            fprintf('Den xwraei 3h seira me panel sto kentro\n')
        
            fprintf('H trith seira xwraei %g panel\n',n3)
        end 
        fprintf('H trith seira xwraei %g panel\n',n3)
        end

                %tetarth seira sto kentro 
        n4=0;        
        y_anamesa=y_diathesimo_k-3*(xam_mhkos+skia_panel);
        x_anamesa=4.61-diadromos-d_skias;
        
        
         if y_anamesa>xam_mhkos+2.49+0.96   %na allaxtei pantou
        n4=fix(x_anamesa/l);
           fprintf('H tetarth seira xwraei %g panel sto kentro\n\n',n4)
         elseif y_anamesa-xam_mhkos>0
            s=y_anamesa+0.6-xam_mhkos;
            l1=3-s;                         %kommati skias  kata y logw klimakostasio
            l2=3.45-s;                      %kommati skias kata y logw thermosifwna
            
            if l1>0
                d1=tand(phi_skias_klim)*l1;      %kommati skias kata x logw klimakostasio
            else
                d1=0;
            end
            
            if l2>0
                d2=tand(phi_skias_therm)*l2;     %kommati skias kata x logw thermosifwna
            else
                d2=0;
            end
            
            x_temp=4.61-max(diadromos,d1)-max(d2,d_skias);
            n4=fix(x_temp/l);
            fprintf('H tetarth seira xwraei %g panel sto kentro\n\n',n4)
         else
             fprintf('H tetarth seira den xwraei panel sto kentro\n\n')
            
         end  
    
end
f1=[n1+n2+n3+n4,power*(n1+n2+n3+n4)];
f2=[kind,' ',seira_vash,' ',panel_orientation];
end

