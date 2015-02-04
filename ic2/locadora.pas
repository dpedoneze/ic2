{
Autor: David Asbahr Pedoneze
Ciencias da ComputaÁ„o - Integral
Ano : 2009

Programa Fim de Curso de IC2

}
program Trab_IC2;

USES CRT, DOS;          {DOS - getdate | PRINTER Impressora}

type   T_clientes = record
        codigo,
        nome,
        tel,
        ende,
        cpf : string;
        end;

       T_data = record
       d,
       m,
       a : word;
       end;

       T_historico = record
        cliente : string;
        dloc,
        ddev : T_data;
       end;

       T_bhist = record
        veiculo,
        cliente,
        tipo : string;
        dloc,
        ddev : T_data;
       end;

       T_veiculos = record
        codigo,
        tipo,
        ac,
        som,
        aux,
        modelo,
        loc : string;
        hist : T_historico;
       end;

//##############################################################################

var     bdCli : file of T_clientes;
        bdCli_bkp : file of T_clientes;
        auxC : T_clientes;
        bdVei : file of T_veiculos;
        bdVei_bkp : file of T_veiculos;
        auxV : T_veiculos;
        bdHis : file of T_bhist;
        auxH : T_bhist;

        r : char;
        menu, smenu : integer;

//##############################################################################

function isSN(var r : char): boolean;

begin
     isSN:=true;
     while ((r <> 's') AND (r <> 'N') AND (r <> 'n') AND (r <> 'S')) do begin
           writeln('Opcao Incorreta, Por favor informe outra.');
           readln(r);
           isSN:=false;
     end;
end;

function sn(var r:char):boolean;

          begin  sn := false;

               if (r in ['s','S']) then
                    sn:=true
               else if ( r in ['N','n'] ) then
                    sn:=false;
          end;

//##############################################################################

function eL(palavra:string):boolean;
         const    letras = ['A'..'Z','a'..'z',' '];
         var tam,i : integer;
begin
     tam := Length(palavra);

     eL:=false;

     for i:=1 to tam do begin
         if palavra[i] in letras then
             eL:=true
         else begin
             eL:=false;
             break;
         end;
     end;
end;

//##############################################################################

function eN(n:string):boolean;
         const    nr = ['0'..'9'];
         var tam,i : integer;
begin
     tam := Length(n);

     eN:=false;

     for i:=1 to tam do begin
         if n[i] in nr then
             eN:=true
         else begin
             eN:=false;
             break;
         end;
     end;
end;

//##############################################################################

function allUP(s:string):string;
      var i,tam : integer;
      aux ,aux2: string;
begin

     aux := '';
     aux2 := '';
     tam := 0;

     tam := length(s);
     for i:=1 to tam do begin
         aux := copy(s,i,1);
             if not eN(aux) then
                aux := upcase(aux);

         aux2 := aux2 + aux;

    end;

    allUP:=aux2;

    aux2 := '';
    aux := '';
    tam := 0;
    end;

//##############################################################################

procedure verfArq(); {verifica se arquivos est„o criados }
          begin
               {$I-}
               reset(bdCli);
               {$I+}

               {$I-}
               reset(bdVei);
               {$I+}

               {$I-}
              reset(bdHis);
              {$I+}

               //if(FILEEXISTS(bdCli)) then begin     DEV PASCAL N√O ACEITA
               if(IOresult <> 0) then begin

                    writeln('------------------[ ERRO ]------------------');
                    writeln('Banco de Dados nao encontrado.');
                    writeln('Criando novo banco de dados....');
                    rewrite(bdCli);
                    rewrite(bdVei);
                    rewrite(bdHis);
                    writeln('Banco de Dados criado com sucesso!');
                    writeln('Enter para prosseguir');
                    readkey;

                    clrscr;
               end;
           end;

//##############################################################################

function vr(r:integer):integer;  //verifica resposta

begin

     write('Opcao: ');
     {$I-}
     read(r);
     {$I+}

     while (IOresult <> 0) do begin
           writeln('Opcao Incorreta, Por favor informe outra. (Numero)');
           {$i-}
           read(r);
           {$I+}
     end;
     vr:=r;
end;

//##############################################################################

function eE(resp:string):boolean;

begin
     eE:=true;
               if ((resp = '') OR (resp = ' ')) then
                  eE:=false;
end;


//##############################################################################

function tv (tp:string):string;

begin
     if tp = '1' then tv:='Carro Popular'
     else if tp = '2' then tv:='Van'
     else if tp = '3' then tv:='Carro Luxo'
     else if tp = '4' then tv:='Moto'
     else
         tp:='Sem Tipo';
end;

//##############################################################################


procedure limpaArqC();

begin

     assign(bdCli_bkp,'bdCli2.BIN');
     rewrite(bdCli_bkp);

     seek(bdCli,0);
     seek(bdCli_bkp,0);

     while not EOF (bdCli) do begin
           read(bdCli,auxC);
            if (auxC.codigo <> 'Excluido') then
              write(bdCli_bkp,auxC);
    end;

    rewrite(bdCli);
    seek(bdCli_bkp,0);
    seek(bdCli,0);

    while not EOF (bdCli_bkp) do begin
          read(bdCli_bkp,auxC);
          write(bdCli,auxC);
    end;

   rewrite(bdCli_bkp);
   close(bdCli_bkp);

end;


procedure limpaArqV();

begin

     assign(bdVei_bkp,'bdVei2.BIN');
     rewrite(bdVei_bkp);

     seek(bdVei,0);
     seek(bdVei_bkp,0);

     while not EOF (bdVei) do begin
           read(bdVei,auxV);
            if (auxC.codigo <> 'Excluido') then
              write(bdVei_bkp,auxV);
    end;

    rewrite(bdVei);
    seek(bdVei_bkp,0);
    seek(bdVei,0);

    while not EOF (bdVei_bkp) do begin
          read(bdVei_bkp,auxV);
          write(bdVei,auxV);
    end;

   rewrite(bdVei_bkp);
   close(bdVei_bkp);

end;

//                    ## VEICULOS ##
//##############################################################################

function buscaV(codigo:string):boolean;

begin        seek(bdVei,0);

        buscaV:=true;
        while not EOF (bdVei) do begin
               read(bdVei,auxV);

               if (codigo = auxV.codigo) then begin
                  buscaV:=false;
                  break;
                  end;
        end;
end;


//##############################################################################

procedure cadVei();
    var auxx : string;
Begin

   with auxV do begin
        readln;

        write('Qual o Codigo: ');
        readln(auxx);

        while ((not buscaV(auxx)) OR (not eE(auxx))) do begin
           writeln('Codigo ja existente/incorreto. Informe um novo codigo.');
           readln(auxx);
        end;

           write('Qual o tipo [carro popular (1), van (2), carro luxo (3), moto (4)]: ');
           readln(tipo);

        while((tipo <> '4') AND (tipo <> '3') AND (tipo <> '2') AND (tipo <> '1')) do begin
              writeln('Tipo incorreto. Informe um novo tipo.');
              readln(tipo);
        end;

        write('Modelo : ');
        readln(modelo);
        modelo := allUP(modelo);

        if ((tipo = '3') OR (tipo = '2') OR (tipo = '1')) then begin
           write('Ar Condicionado [s/n]: ');
           readln(r);
           isSN(r);
           if ((r = 's') OR (r = 'S')) then
           ac := 'SIM'
           else
           ac := 'NAO';

           write('Som [s/n]: ');
           readln(r);
           isSN(r);
           if ((r = 's') OR (r = 'S')) then
           som := 'SIM'
           else
           som := 'NAO';

       end;

        if tipo = '1' then begin
           write('Direcao Hidraulica [s/n]: ');
           readln(r);
           isSN(r);
           if ((r = 's') OR (r = 'S')) then
           aux := 'SIM'
           else
           aux := 'NAO';

        end

        else if (tipo = '2') then begin
           write('Numero de Passageiros : ');
           readln(aux);
           while (not eN(aux)) do begin
                 write('Dado incorreto. Numero de Passageiros: ');
                 readln(aux);
           end;
        end;

           writeln;
           writeln('Confirmar Cadastro? [s/n]');

        auxV.codigo := auxx;
        auxV.hist.ddev.a := 0;
        auxV.hist.ddev.m := 0;
        auxV.hist.ddev.d := 0;
        auxV.hist.dloc.a := 0;
        auxV.hist.dloc.m := 0;
        auxV.hist.dloc.d := 0;
        auxV.loc := '0';


           readln(r);
           isSN(r);
           if sn(r) then begin
                                seek(bdVei,FileSize(bdVei));
                                write(bdVei,auxV);
                                writeln('Cadastro de (',auxV.codigo,') ',modelo,' realizado!');
                                readkey;
                     end;
        end;
end;

//##############################################################################

function conVei():boolean;

          var      pos : integer;
Begin
      conVei := True;
   with auxV do begin

        readln;
        write('Qual o Codigo: ');
        readln(codigo);

        if ((not buscaV(codigo)) OR (not eE(codigo))) then begin

           pos := Filepos(bdVei);
           seek(bdVei,pos-1);
           read(bdVei,auxV);

             writeln;
             writeln('Tipo: ',tv(auxV.tipo));
             writeln('Modelo: ',auxV.modelo);

        if ((tipo = '3') OR (tipo = '2') OR (tipo = '1')) then begin
           writeln('Ar Condicionado [s/n]: ',ac);
           writeln('Som [s/n]: ',som);
        end;

        if tipo = '1' then
           writeln('Direcao Hidraulica [s/n]: ',aux);

        if (tipo = '2') then
           writeln('Numero de Passageiros : ',aux);
        end

        else begin
            writeln('Veiculo nao encontrado!');
            conVei:= False;
        end;


    end;
        readkey;
end;

//##############################################################################

procedure excVei();

          var      pos,i,a : integer;
Begin
   a :=0;
   with auxV do begin

        readln;
        write('Qual o Codigo: ');
        readln(codigo);

        if ((buscaV(codigo)) AND (eE(codigo))) then
         a := 1
         else begin

           pos := Filepos(bdVei);
           seek(bdVei,pos-1);
           read(bdVei,auxV);

             writeln;
             writeln('Tipo: ',tv(auxV.tipo));
             writeln('Modelo: ',auxV.modelo);

             if ((tipo = '3') OR (tipo = '2') OR (tipo = '1')) then begin
                writeln('Ar Condicionado [s/n]: ',ac);
                writeln('Som [s/n]: ',som);
                end;

             if tipo = '1' then
                writeln('Direcao Hidraulica [s/n]: ',aux);

             if (tipo = '2') then
                writeln('Numero de Passageiros : ',aux);

         i := 0;
         seek(bdCli,0);
         while not EOF (bdCli) do begin
            read(bdCli,auxC);
            if((hist.cliente = auxC.codigo) AND (loc = '1')) then begin
                 writeln;
                 writeln('O veiculo esta locado!');
                 i := 1;
                  writeln;
                 writeln('Nome: ',auxC.nome);
                 writeln('Telefone: ',auxC.tel);
                 writeln('Codigo: ',auxC.codigo);
            end;
         end;

           writeln;
           writeln('Confirmar Exclusao? [s/n]');
           readln(r);
           isSN(r);
           if ((sn(r)) AND (i = 0)) then begin
              seek(bdVei,pos-1);
              auxV.codigo := 'Excluido';
              write(bdVei,auxV);
              writeln('Cadastro Excluido!');
              close(bdVei);
              reset(bdVei);
              limpaArqV();

           end
           else begin
                 if sn(r) then begin
                writeln('Nao foi possivel excluir o carro! (Pendencias)');

                readkey;
                end;
           end;
        end;

        end;
        if a = 1 then begin
             writeln('Veiculo nao encontrado!');
        readkey;
   end;
end;

//##############################################################################

procedure altVei();
          var      pos : integer;
                   auxx,tipo2 : string;
Begin
if (conVei()) then begin

   with auxV do begin

        if ((not buscaV(codigo)) OR (not eE(codigo))) then begin

           pos := Filepos(bdVei);
           seek(bdVei,pos-1);
           read(bdVei,auxV);

           writeln;
           gotoxy(5,13);
           writeln('(Enter para nao alterar)');
           writeln('(Atencao, para s/n devera responder novamente!)');
           writeln;

             write('Novo tipo [carro popular (1), van (2), carro luxo (3), moto (4)]: ');
             readln(auxx);
                  if (auxx <> '') then begin
                       while((auxx <> '4') AND (auxx <> '3') AND (auxx <> '2') AND (auxx <> '1')) do begin
                            writeln('Tipo incorreto. Informe um novo tipo.');
                            readln(auxx);
                       end;
                       tipo2 := tipo;
                       tipo := auxx;
                  end;

             write('Novo Modelo: ');
             readln(auxx);
                  if (auxx <> '') then
                     modelo := allUP(auxx);

             if ((tipo = '3') OR (tipo = '2') OR (tipo = '1')) then begin
                write('Ar Condicionado [s/n]: ');
                readln(r);
                  if (r <> '') then begin

                  isSN(r);
                     if ((r = 's') OR (r = 'S')) then
                     ac := 'SIM'
                     else
                     ac := 'NAO';
                  end;

                write('Som [s/n]: ');
                readln(r);
                  if (r <> '') then begin

                  isSN(r);
                      if ((r = 's') OR (r = 'S')) then
                     som := 'SIM'
                     else
                     som := 'NAO';
                  end;

             end
             else begin
                  ac := '';
                  som := '';
                  end;

             if tipo = '1' then begin
                if tipo2 = '1' then aux := '';
                write('Direcao Hidraulica [s/n]: ');
             readln(r);
                  if (r <> '') then begin

                  isSN(r);
                      if ((r = 's') OR (r = 'S')) then
                     aux := 'SIM'
                     else
                     aux := 'NAO';
                  end;

             end

             else if (tipo = '2') then begin
                  if tipo2 = '1' then aux := '';
                write('Numero de Passageiros : ');
                readln(auxx);
                  if (auxx <> '') then begin
                     while (not eN(auxx)) do begin
                           write('Dado incorreto. Numero de Passageiros: ');
                           readln(auxx);
                     end;
                     aux := auxx;
                  end;

             end
             else aux := '';

        writeln;
        writeln('Confirmar Alteracao? [s/n]');
           readln(r);
           isSN(r);
           if sn(r) then begin
           seek(bdVei,pos-1);
           write(bdVei,auxV);
           writeln('Cadastro de ',auxV.modelo,' atualizado!');
           close(bdVei);
           reset(bdVei);
           end;

        end
        else
             writeln('Cliente nao encontrado!');

        readln;
   end;
end;
end;


//                          ###  CLIENTES ###
//##############################################################################

function buscaC(codigo:string):boolean;

begin        seek(bdCli,0);

        buscaC:=true;
        while not EOF (bdCli) do begin
               read(bdCli,auxC);

               if (codigo = auxC.codigo) then begin
                  buscaC:=false;
                  break;
                  end;
        end;
end;

//##############################################################################

procedure cadCli();
    var aux : string;
        tcpf,ttel : integer;
Begin

   with auxC do begin
        readln;

        write('Qual o Codigo: ');
        readln(aux);

        while ((not buscaC(aux)) OR (not eE(aux))) do begin
           writeln('Codigo ja existente/incorreto. Informe um novo codigo.');
           readln(aux);
        end;

           write('Qual o nome: ');
           readln(nome);

        while (not eL(nome)) do begin
              writeln('Nome incorreto. Informe um novo nome.');
              readln(nome);
        end;

           write('Qual o telefone: ');
           readln(tel);

              ttel := length(tel);
              while ((ttel <> 10) OR (not en(tel))) do begin
                    writeln('Informe somente os digitos do telefone + DDD (10)');
                    readln(tel);
                    ttel := length(tel);
              end;

             tel := '(' + copy(tel,0,2) + ') ' + copy(tel,3,4) + ' - ' + copy(tel,7,4);
            // writeln(tel);

           write('Qual o endereco: ');
           readln(ende);

           write('Qual o CPF: ');
           readln(cpf);

              tcpf := length(cpf);
              while ((tcpf <> 11) OR (not en(cpf))) do begin
                    writeln('Informe somente os digitos do CPF (11)');
                    readln(cpf);
                    tcpf := length(cpf);
              end;

             cpf := copy(cpf,0,3) + '.' + copy(cpf,4,3) + '.' + copy(cpf,7,3) + '-' + copy(cpf,10,2);
             //writeln(cpf);

           writeln;
           writeln('Confirmar Cadastro? [s/n]');
           readln(r);

        auxC.codigo := aux;

           isSN(r);
           if sn(r) then begin
                        seek(bdCli,FileSize(bdCli));
                        write(bdCli,auxC);
                        writeln('Cadastro de (',auxC.codigo,')',nome,' realizado!');
                        readln;
                     end;
          end;
end;

//##############################################################################

procedure conCli();

          var      pos : integer;
Begin

   with auxC do begin

        readln;
        write('Qual o Codigo: ');
        readln(codigo);

        if ((not buscaC(codigo)) OR (not eE(codigo))) then begin

           pos := Filepos(bdCli);
           seek(bdCli,pos-1);
           read(bdCli,auxC);

             writeln;
             writeln('Nome: ',auxC.nome);
             writeln('Telefone: ',auxC.tel);
             writeln('Endereco: ',auxC.ende);
             writeln('CPF: ',auxC.cpf);
        end
        else
             writeln('Cliente nao encontrado!');

             readln;
   end;
end;

//##############################################################################

procedure excCli();

          var      pos,i,a : integer;

Begin
   i := 0;
   a := 0;
   with auxC do begin

        readln;
        write('Qual o Codigo: ');
        readln(codigo);

        if ((buscaC(codigo)) AND (eE(codigo))) then
         a := 1
         else begin
           pos := Filepos(bdCli);
           seek(bdCli,pos-1);
           read(bdCli,auxC);

             writeln;
             writeln('Nome: ',auxC.nome);
             writeln('Telefone: ',auxC.tel);
             writeln('Endereco: ',auxC.ende);
             writeln('CPF: ',auxC.cpf);

         seek(bdVei,0);
         while not EOF (bdVei) do begin
            read(bdVei,auxV);
             //writeln(auxV.hist.cliente = auxC.codigo,' ',auxV.loc);
             //readkey;
            if((auxV.hist.cliente = auxC.codigo) AND (auxV.loc = '1')) then begin
                if i = 0 then begin
                 writeln;
                 writeln('O cliente possui locacao(oes) pendente(s)!');
                 i := 1;
                end;
                 writeln;
                 writeln('Modelo: ',auxV.modelo);
                 writeln('Tipo: ',tv(auxV.tipo));
                 writeln('Codigo: ',auxV.codigo);
            end;
         end;

           //if(i = 0) then begin
                writeln;
                writeln('Confirmar Exclusao? [s/n]');
                readln(r);
                isSN(r);
                if ((sn(r)) AND (i = 0)) then begin
                   seek(bdCli,pos-1);
                   auxC.codigo := 'Excluido';
                   write(bdCli,auxC);
                   writeln('Cadastro Excluido!');
                   close(bdCli);
                   reset(bdCli);
                   limpaArqC();
                   readkey;
           end
           else begin
                 if sn(r) then begin
                writeln('Nao foi possivel excluir o carro! (Pendencias)');

                readkey;
                end;
           end;
        end;
        if a = 1 then begin
             writeln('Cliente nao encontrado!');
             readkey;
        end;
   end;
end;

//##############################################################################

procedure altCli();
          var      pos,ttel,tcpf : integer;
                   aux : string;
Begin

   with auxC do begin

        readln;
        write('Qual o Codigo: ');
        readln(codigo);

        if ((not buscaC(codigo)) OR (not eE(codigo))) then begin

           pos := Filepos(bdCli);
           seek(bdCli,pos-1);
           read(bdCli,auxC);

       gotoxy(5,7);
       writeln('(Enter para nao alterar)');

             writeln;
             writeln('Nome: ',auxC.nome);
             writeln('Telefone: ',auxC.tel);
             writeln('Endereco: ',auxC.ende);
             writeln('CPF: ',auxC.cpf);


             writeln;
write('Novo Nome: ');
              readln(aux);
                   if (aux <> '') then begin
        while (not eL(aux)) do begin
              writeln('Nome incorreto. Informe um novo nome.');
              readln(aux);
        end;
        auxC.nome := aux;
        end;

 write('Novo Telefone: ');
             readln(aux);
                  if (aux <> '') then begin

              ttel := length(aux);
              while ((ttel <> 10) or (not eN(aux))) do begin
                    writeln('Informe somente os digitos do telefone + DDD (10)');
                    readln(aux);
                   ttel := length(aux);
             end;

             aux := '(' + copy(aux,0,2) + ') ' + copy(aux,3,4) + ' - ' + copy(aux,7,4);

                     auxC.tel := aux;

                  end;

 write('Novo Endereco: ');
             readln(aux);
                  if (aux <> '') then
                     auxC.ende := aux;

  write('Novo CPF: ');
             readln(aux);
                  if (aux <> '') then begin

              tcpf := length(aux);
              while ((tcpf <> 11) or (not eN(aux))) do begin
                    writeln('Informe somente os digitos do CPF (11)');
                    readln(aux);
                   tcpf := length(aux);
             end;

             aux := copy(aux,0,3) + '.' + copy(aux,4,3) + '.' + copy(aux,7,3) + '-' + copy(aux,10,2);


                     auxC.cpf := aux;
                     end;

        writeln;
        writeln('Confirmar Alteracao? [s/n]');
           readln(r);
           isSN(r);
           if sn(r) then begin
           seek(bdCli,pos-1);
           write(bdCli,auxC);
           writeln('Cadastro de ',auxC.nome,' atualizado!');
           close(bdCli);
           reset(bdCli);
           readkey;
           end;

        end
        else begin
             writeln('Cliente nao encontrado!');
        readkey;
        end;
   end;
end;

//##############################################################################

procedure locVei();
          var a, m, d, s : word;
              codigo : string;
              posV,posC : integer;

 begin
         readln;
         writeln('    VEICULO');
         writeln;
         write('Codigo: ');
         readln(codigo);

         if ((not buscaV(codigo)) OR (not eE(codigo))) then begin

           posV := Filepos(bdVei);
           seek(bdVei,posV-1);
           read(bdVei,auxV);
           getdate(a,m,d,s);

           if(auxV.loc = '1') then begin
              writeln('Veiculo esta Locado!');
              readln;
           end
              else begin
                     writeln('Veiculo: ',auxV.modelo);
                     writeln('Tipo: ',tv(auxV.tipo));
                     writeln;
                     writeln;
                     writeln('    CLIENTE');
                     writeln;
                     write('Codigo: ');

                     readln(codigo);

                     if ((not buscaC(codigo)) OR (not eE(codigo))) then begin

                        posC := Filepos(bdCli);
                        seek(bdCli,posC-1);
                        read(bdCli,auxC);

                        writeln('Nome: ',auxC.nome);
                        writeln;
                        writeln('Confirmar Locacao? [s/n]');
                        readln(r);

                        isSN(r);
                      if sn(r) then begin

                         auxV.hist.dloc.d := d;
                         auxV.hist.dloc.m := m;
                         auxV.hist.dloc.a := a;

                         auxV.hist.ddev.d := 0;
                         auxV.hist.ddev.m := 0;
                         auxV.hist.ddev.a := 0;

                         auxV.hist.cliente := auxC.codigo;
                         auxV.loc := '1';

                         seek(bdVei,posV-1);
                         write(bdVei,auxV);

                         writeln('Veiculo ',auxV.modelo,' locado!');
                         close(bdVei);
                         reset(bdVei);
                         readln;

                         with auxH do begin
                              veiculo := auxV.codigo;
                              cliente := auxC.codigo;
                              dloc.d := d;
                              dloc.m := m;
                              dloc.a := a;
                              ddev.d := 0;
                              ddev.m := 0;
                              ddev.a := 0;
                              tipo := auxV.tipo;
                         end;

                         //### Registrando no Historico.bin
                         seek(bdHis,FileSize(bdHis));
                         write(bdHis,auxH);

                      end;
                      end
                      else begin
                          writeln('Cliente nao encontrado!');
                          readkey;
                          end;
                end;
         end
         else begin
              writeln('Veiculo nao cadastrado!');
              locVei();
         end;

 end;

//##############################################################################

procedure devVei();

          var a, m, d, s : word;
              codigo : string;
              posV,posC,posH : integer;

 begin
         readln;
         writeln('    VEICULO');
         writeln;
         write('Codigo: ');
         readln(codigo);

         if ((not buscaV(codigo)) OR (not eE(codigo))) then begin

           posV := Filepos(bdVei);
           seek(bdVei,posV-1);
           read(bdVei,auxV);
           getdate(a,m,d,s);

           if (auxV.loc = '1') then begin

                     writeln('Veiculo: ',auxV.modelo);
                     writeln('Tipo: ',tv(auxV.tipo));
                     writeln;
                     writeln;
                     writeln('    CLIENTE');
                     writeln;
                     writeln('Codigo: ',auxV.hist.cliente);

                     if ((not buscaC(auxV.hist.cliente)) OR (not eE(auxV.hist.cliente))) then begin

                        posC := Filepos(bdCli);
                        seek(bdCli,posC-1);
                        read(bdCli,auxC);

                        writeln('Nome: ',auxC.nome);
                        writeln;
                        writeln('Confirmar Devolucao? [s/n]');
                        readln(r);
                        isSN(r);
                      if sn(r) then begin

                         auxV.hist.ddev.d := d;
                         auxV.hist.ddev.m := m;
                         auxV.hist.ddev.a := a;
                         auxV.loc := '0';

                         seek(bdVei,posV-1);
                         write(bdVei,auxV);

                        while not EOF (bdHis) do begin
                              read(bdHis,AuxH);
                              if ((auxH.cliente = auxC.codigo) AND (auxH.veiculo = auxV.codigo)) then
                              break;
                        end;

                         with auxH do begin
                              ddev.d := d;
                              ddev.m := m;
                              ddev.a := a;
                         end;

                         //### Registrando no Historico.bin
                         posH := filepos(bdHis);
                         seek(bdHis,posH-1);
                         write(bdHis,auxH);

                         writeln('Veiculo ',auxV.modelo,' devoluido!');
                         readln;
                         close(bdVei);
                         reset(bdVei);
                      end;
                     end;
                 end
                 else begin
                      writeln('Veiculo nao esta Locado!');
                      devVei;

                 end;
        end
        else begin
             writeln('Veiculo nao encontrado!');
             readkey;
        end;
end;

//##############################################################################

procedure balAce();
          var a, m, d, s : word;
          i,cont,b : integer;
          tpt : array[1..4] of integer;
          modelo,tipo,cod : array[1..100] of string;           //Limitado a 100;
          qtd : array[1..100] of integer;
begin
           getdate(a,m,d,s);
           readln;
           writeln(d,'/',m,'/',a,'       Balanco do Acervo');


                     for i:=1 to 100 do begin
                         modelo[i] := '';
                         qtd[i] := 0;
                     end;

         seek(bdVei,0);

                     for i:=1 to 4 do
                     tpt[i] := 0;
                     cont := 1;
                     b := 1;

        while not EOF (bdVei) do begin
              read(bdVei,auxV);
                if(auxV.codigo <> 'Excluido') then begin
                  if (auxV.tipo = '1') then
                     tpt[1] := tpt[1] + 1
                  else if (auxV.tipo = '2') then
                     tpt[2] := tpt[2] + 1
                  else if (auxV.tipo = '3') then
                     tpt[3] := tpt[3] + 1
                  else if (auxV.tipo = '4') then
                     tpt[4] := tpt[4] + 1;

                     modelo[cont] := auxV.modelo;
                     tipo[cont] := auxV.tipo;
                     cod[cont] := auxV.codigo;
                     cont := cont + 1;
                end;
        end;

        while(b < cont) do begin
                for i:=1 to cont-1 do begin
                    if (modelo[b] = modelo[i]) then begin
                       qtd[b] := qtd[b] + 1;
                       if (i <> b) then modelo[i] := '';
                    end;
                end;
                b := b + 1;
        end;

        gotoxy(2,7); write('COD'); gotoxy(7,7); write('VEICULO'); gotoxy(30,7); write('TIPO'); gotoxy(45,7); writeln('QUANTIDADE');
        cont := 1;

        for i:=1 to b do begin
            if ((qtd[i] > 0) AND (modelo[i] <> '')) then begin
              gotoxy(1,cont+8); write(cod[i]); gotoxy(7,cont+8); write(modelo[i]); gotoxy(30,cont+8); write(tv(tipo[i])); gotoxy(50,cont+8); writeln(qtd[i]);
               cont := cont + 1;
            end;
        end;


        writeln;
        writeln;
        writeln('Total por Tipo');
        writeln;
        writeln('     Carros Populares: ',tpt[1]);
        writeln('     Vans: ',tpt[2]);
        writeln('     Carros Luxo: ',tpt[3]);
        writeln('     Motos: ',tpt[4]);
        writeln('     Total: ',tpt[1]+tpt[2]+tpt[3]+tpt[4]);
        writeln;
        writeln;
        writeln('( Enter para voltar)');
        readkey;
end;

//##############################################################################

procedure balMov();
          var a, m, d, s : word;
          i,j,i2,tc,cont,aux: integer;
          tpt : array[1..4] of integer;
          modelo,tipo,cod : array[1..100] of string;
          qtd : array[1..100] of integer;
          auxs : string;

begin
           getdate(a,m,d,s);
           readln;
           writeln(d,'/',m,'/',a,'       Balanco de Locacoes');


           //# Inicializa as Variaveis

                     for i:=1 to 4 do
                     tpt[i] := 0;
                     tc := 0;

                     for i:= 1 to 100 do begin
                         qtd[i] := 0;
                         modelo[i] := '';
                         tipo[i] := '';
                         cod[i] := '';
                     end;

        seek(bdCli,0);
        while not EOF (bdCli) do begin

                 read(bdCli,auxC);
                 if auxC.codigo <> 'Excluido' then
                 tc := tc + 1;
        end;

        seek(bdVei,0);
        while not EOF (bdVei) do begin
              read(bdVei,auxV);
                  if auxV.codigo <> 'Excluido' then begin
                  if (auxV.tipo = '1') then
                     tpt[1] := tpt[1] + 1
                  else if (auxV.tipo = '2') then
                     tpt[2] := tpt[2] + 1
                  else if (auxV.tipo = '3') then
                     tpt[3] := tpt[3] + 1
                  else if (auxV.tipo = '4') then
                     tpt[4] := tpt[4] + 1;
                  end;

        end;

        writeln;
        writeln('Total de Clientes: ',tc);
        writeln('Total de Veiculos no Acervo: ',tpt[1]+tpt[2]+tpt[3]+tpt[4]);
        writeln;
        writeln;
        writeln('Total por Tipo');
        writeln;
        writeln('     Carros Populares: ',tpt[1]);
        writeln('     Vans: ',tpt[2]);
        writeln('     Carros Luxo: ',tpt[3]);
        writeln('     Motos: ',tpt[4]);

                     for i:=1 to 4 do
                     tpt[i] := 0;

        seek(bdHis,0);
        while not EOF (bdHis) do begin
              read(bdHis,auxH);

                  if ((auxH.tipo = '1') AND (auxH.dloc.m = m)) then
                     tpt[1] := tpt[1] + 1
                  else if ((auxH.tipo = '2') AND (auxH.dloc.m = m)) then
                     tpt[2] := tpt[2] + 1
                  else if ((auxH.tipo = '3') AND (auxH.dloc.m = m)) then
                     tpt[3] := tpt[3] + 1
                  else if ((auxH.tipo = '4') AND (auxH.dloc.m = m)) then
                     tpt[4] := tpt[4] + 1;

        end;

        writeln;
        writeln;
        writeln('Total de Locacoes no Mes');
        writeln;
        writeln('     Carros Populares: ',tpt[1]);
        writeln('     Vans: ',tpt[2]);
        writeln('     Carros Luxo: ',tpt[3]);
        writeln('     Motos: ',tpt[4]);
        writeln('     Total: ',tpt[1]+tpt[2]+tpt[3]+tpt[4]);
        writeln;
        writeln;
        writeln('Media de Locacoes por Cliente: ',(tpt[1]+tpt[2]+tpt[3]+tpt[4])/tc:0:2);

        //top 10 veiculos

cont := 1;
if (((tpt[1]+tpt[2]+tpt[3]+tpt[4]) > 0) AND (tc <> 0)) then begin

        seek(bdVei,0);

        while not EOF (bdVei) do begin
              read(bdVei,AuxV);
              seek(bdHis,0);
              while not EOF (bdHis) do begin
                    read(bdHis,auxH);
                    if (auxV.codigo = auxH.veiculo) then begin
                       qtd[cont] := qtd[cont] + 1;
                       modelo[cont] := auxV.modelo;
                       tipo[cont] := auxV.tipo;
                       cod[cont] := auxH.veiculo;
                    end;
              end;
             cont := cont + 1;
        end;
        writeln;
        writeln(' 10 Veiculos mais Locados');
        writeln;

        for i:=100 downto 2 do               //bubble_sort on :D
            for j := 1 to i-1 do
                if (qtd[j] < qtd[j+1]) then begin
                   aux := qtd[j];
                   qtd[j] := qtd[j+1];
                   qtd[j+1] := aux;

                   auxs := modelo[j];
                   modelo[j] := modelo[j+1];
                   modelo[j+1] := auxs;

                   auxs := tipo[j];
                   tipo[j] := tipo[j+1];
                   tipo[j+1] := auxs;

                   auxs := cod[j];
                   cod[j] := cod[j+1];
                   cod[j+1] := auxs;
                end;

        if cont > 10 then
           cont := 10;

        gotoxy(4,32); write('Cod.'); gotoxy(10,32); write('Veiculo'); gotoxy(30,32); write('Tipo'); gotoxy(45,32); writeln('Nro. Locacoes');
        i2 := 1;
        writeln;
        for i:=1 to cont do begin
            if (qtd[i] > 0) then begin
            write(i2,'-');gotoxy(4,33+i2); write(cod[i]); gotoxy(10,33+i2); write(modelo[i]); gotoxy(30,33+i2); write(tv(tipo[i])); gotoxy(52,33+i2); writeln(qtd[i]);
            i2 := i2 + 1;
            end;
        end;

        //writeln;
        gotoxy(1,45); write(' 10 Melhores Clientes');
        seek(bdCli,0);

        for i:=1 to 100 do begin
            qtd[i] := 0;
            modelo[i] := '';
            tipo[i] := '';
            cod[i] := '';
        end;

        while not EOF (bdCli) do begin
              read(bdCli,AuxC);
              seek(bdHis,0);
              while not EOF (bdHis) do begin
                    read(bdHis,auxH);
                    if (auxC.codigo = auxH.cliente) then begin
                       qtd[cont] := qtd[cont] + 1;
                       modelo[cont] := auxC.nome;
                       cod[cont] := auxH.cliente;
                    end;
              end;
             cont := cont + 1;
        end;

        for i:=100 downto 2 do               //bubble_sort on :D
            for j := 1 to i-1 do
                if (qtd[j] < qtd[j+1]) then begin
                   aux := qtd[j];
                   qtd[j] := qtd[j+1];
                   qtd[j+1] := aux;

                   auxs := modelo[j];         //nome
                   modelo[j] := modelo[j+1];
                   modelo[j+1] := auxs;

                   auxs := cod[j];
                   cod[j] := cod[j+1];
                   cod[j+1] := auxs;
                end;

        if cont > 10 then
           cont := 10;

        gotoxy(4,47); write('Cod.'); gotoxy(10,47); write('Nome'); gotoxy(45,47); writeln('Nro. Locacoes');
        i2 := 1;
        writeln;
        for i:=1 to cont do begin
            if (qtd[i] > 0) then begin
            write(i2,'-');gotoxy(4,48+i2); write(cod[i]); gotoxy(10,48+i2); write(modelo[i]);gotoxy(52,48+i2); writeln(qtd[i]);
            i2 := i2 + 1;
            end;
        end;
end
else begin
        writeln(' 10 Veiculos mais Locados');
        writeln;
        writeln('Nao ha veiculos locados!');
        writeln;
        writeln;
        writeln(' 10 Melhores Clientes');
        writeln;
        writeln('Nao ha veiculos locados!');

end;
        writeln;
        writeln;
        writeln('( Enter para voltar)');
        readkey;
end;

//##############################################################################

Begin

assign(bdCli,'bdCli.BIN');
assign(bdVei,'bdVei.BIN');
assign(bdHis,'bdHis.BIN');
verfArq();

menu := 9;
while (menu <> 0) do begin

writeln('    IC2 SOLUCOES EM SOFTWARE');
writeln('CONTROLE DE LOCADORA DE VEICULOS');
writeln('--------------------------------');
writeln;

writeln('1 - CADASTRO DE CLIENTES');
writeln('2 - CADASTRO DE VEICULOS');
writeln('3 - MOVIMENTACAO');
writeln('4 - RELATORIOS');
writeln('0 - FINALIZAR');
menu := vr(menu);
clrscr;

case menu of

     1 : begin
              writeln('    IC2 SOLUCOES EM SOFTWARE');
              writeln('CONTROLE DE LOCADORA DE VEICULOS');
              writeln('--------------------------------');
              writeln;
              writeln('CADASTRO DE CLIENTES');
              writeln('1 - INCLUSAO');
              writeln('2 - ALTERACAO');
              writeln('3 - CONSULTA');
              writeln('4 - EXCLUSAO');
              writeln('0 - RETORNAR');
              smenu := vr(smenu);

            while (smenu <> 0) do begin
               clrscr;
                             writeln('    IC2 SOLUCOES EM SOFTWARE');
                             writeln('CONTROLE DE LOCADORA DE VEICULOS');
                             writeln('--------------------------------');
                             writeln;

               case smenu of

                    1 : begin
                             cadCli();
                             clrscr;
                             break;
                        end;

                     2 : begin
                             if (filesize(bdCli) = 0) then begin
                                writeln('Nao ha clientes Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             altCli();
                             clrscr;
                             break;
                        end;

                     3 : begin
                             if (filesize(bdCli) = 0) then begin
                                writeln('Nao ha clientes Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             conCli();
                             clrscr;
                             break;
                        end;

                     4 : begin
                             if (filesize(bdCli) = 0) then begin
                                writeln('Nao ha clientes Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             excCli();
                             clrscr;
                             break;
                        end

                    else begin
                         writeln('Opcao Incorreta, Por favor informe outra.');
                         smenu := vr(smenu);
                    end;
               end;
             end;
      end;

      2 : begin
              writeln('    IC2 SOLUCOES EM SOFTWARE');
              writeln('CONTROLE DE LOCADORA DE VEICULOS');
              writeln('--------------------------------');
              writeln;
              writeln('CADASTRO DE VEICULOS');
              writeln('1 - INCLUSAO');
              writeln('2 - ALTERACAO');
              writeln('3 - CONSULTA');
              writeln('4 - EXCLUSAO');
              writeln('0 - RETORNAR');
              smenu := vr(smenu);

            while (smenu <> 0) do begin
               clrscr;
                             writeln('    IC2 SOLUCOES EM SOFTWARE');
                             writeln('CONTROLE DE LOCADORA DE VEICULOS');
                             writeln('--------------------------------');
                             writeln;

               case smenu of

                    1 : begin
                             cadVei();
                             clrscr;
                             break;
                        end;

                     2 : begin
                             if (filesize(bdVei) = 0) then begin
                                writeln('Nao ha veiculos Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             altVei();
                             clrscr;
                             break;
                        end;

                     3 : begin
                             if (filesize(bdVei) = 0) then begin
                                writeln('Nao ha veiculos Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             conVei();
                             clrscr;
                             break;
                        end;

                     4 : begin
                             if (filesize(bdVei) = 0) then begin
                                writeln('Nao ha veiculos Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             excVei();
                             clrscr;
                             break;
                        end

                    else begin
                         writeln('Opcao Incorreta, Por favor informe outra.');
                         smenu := vr(smenu);
                    end;
               end;
             end;
      end;

      3 : begin
              writeln('    IC2 SOLUCOES EM SOFTWARE');
              writeln('CONTROLE DE LOCADORA DE VEICULOS');
              writeln('--------------------------------');
              writeln;
              writeln('MOVIMENTACAO');
              writeln('1 - LOCACAO');
              writeln('2 - DEVOLUCAO');
              writeln('0 - RETORNAR');
              smenu := vr(smenu);

            while (smenu <> 0) do begin
               clrscr;
                             writeln('    IC2 SOLUCOES EM SOFTWARE');
                             writeln('CONTROLE DE LOCADORA DE VEICULOS');
                             writeln('--------------------------------');
                             writeln;

               case smenu of

                    1 : begin
                             if (filesize(bdVei) = 0) then begin
                                writeln('Nao ha veiculos Cadastrados!');
                                readln; readln;
                                break;
                             end
                             else if (filesize(bdCli) = 0) then begin
                                writeln('Nao ha clientes Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             locVei();
                             clrscr;
                             break;
                        end;

                     2 : begin
                             if (filesize(bdVei) = 0) then begin
                                writeln('Nao ha veiculos Cadastrados!');
                                readln; readln;
                                break;
                             end
                             else if (filesize(bdCli) = 0) then begin
                                writeln('Nao ha clientes Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             devVei();
                             clrscr;
                             break;
                        end;

                   else begin
                         writeln('Opcao Incorreta, Por favor informe outra.');
                         smenu := vr(smenu);
                    end;
               end;
             end;
      end;

      4 : begin
              writeln('    IC2 SOLUCOES EM SOFTWARE');
              writeln('CONTROLE DE LOCADORA DE VEICULOS');
              writeln('--------------------------------');
              writeln;
              writeln('RELATORIOS');
              writeln('1 - BALANCO DO ACERVO');
              writeln('2 - BALANCO DE MOVIMENTACOES');
              writeln('0 - RETORNAR');
              smenu := vr(smenu);

            while (smenu <> 0) do begin
               clrscr;
                             writeln('    IC2 SOLUCOES EM SOFTWARE');
                             writeln('CONTROLE DE LOCADORA DE VEICULOS');
                             writeln('--------------------------------');
                             writeln;

               case smenu of

                    1 : begin
                             if (filesize(bdVei) = 0) then begin
                                writeln('Nao ha veiculos Cadastrados!');
                                readln; readln;
                                break;
                             end
                             else if (filesize(bdCli) = 0) then begin
                                writeln('Nao ha clientes Cadastrados!');
                                readln; readln;
                                break;
                             end;

                             balAce();
                             clrscr;
                             break;
                        end;

                     2 : begin
                             if (filesize(bdVei) = 0) then begin
                                writeln('Nao ha veiculos Cadastrados!');
                                readln;
                                readln;
                                break;
                             end
                             else if (filesize(bdCli) = 0) then begin
                                writeln('Nao ha clientes Cadastrados!');
                                readln;
                                readln;
                                break;
                             end;

                                  balMov();
                                  clrscr;
                                  break;
                        end;

                   else begin
                         writeln('Opcao Incorreta, Por favor informe outra.');
                         smenu := vr(smenu);
                    end;
               end;
             end;
      end;

      0 : break

else begin
     writeln('Opcao Incorreta, Por favor informe outra.');
     menu := vr(menu);
end;
end;

clrscr;
end;

close(bdCli);
close(bdVei);
close(bdHis);
end.
