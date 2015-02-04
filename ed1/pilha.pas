{
  ------------------- Desenvolvedor ------------------------
  David Asbahr Pedoneze                 CCD09
  Ra 20700903                        07/04/10

  --------------------- Objetivo ---------------------------
  Utilizar e testar as funÁıes referentes a pilha.


  -------------------- Compilador --------------------------
  Dev-Pascal 1.9.2 (Free Pascal compiler v1.06)

  ----------------------------------------------------------
}

program PilUp;

USES CRT;

type Valor = integer;
     ponteiro = ^Pil;

     Pil = record
         V : Valor;
         prox : ponteiro;
    end;

var Topo : ponteiro;
    menu,e : integer;

//-------------------------------------------------------------
// FunÁ„o para filtro erros

function erros(e:integer):string;

begin
     case e of
          1 : erros:='VAZIA!';
          2 : erros:='CONTEM ELEMENTOS';
     end;
end;

//------------------------------------------------------------
// Procedure que adiciona um novo Topo

procedure push(var p : ponteiro);

var aux : ponteiro;
    V   : Valor;

begin

 write('Valor: '); readln(V);

     if p = nil then begin
        new(p);
        p^.prox := nil;
        p^.V := V;
     end
     else begin
        new(aux);
        aux^.prox := p;
        aux^.V := V;
        p := aux;
     end;

end;

//------------------------------------------------------------
// Procedure que verifica se a Pilha est· vazia

function isPilVaz(p: ponteiro):boolean;
begin
     isPilVaz := false;
     if p = nil then isPilvaz :=true;

end;

//------------------------------------------------------------
// Procedure que deleta o Topo

procedure Pop(var p: ponteiro);

var aux : ponteiro;

begin

     if not(isPilVaz(p)) then begin
          aux := p^.prox;
          dispose(p);
          p := aux;
          writeln('TOPO DELETADO!');
     end
     else
          writeln(erros(1));


end;

//------------------------------------------------------------
// Procedure que Esvazia a Pilha

procedure EsvPil (var p: ponteiro);

begin
     if not(isPilVaz(p)) then begin
     while not(isPilVaz(p)) do
           pop(p);

     writeln('ESVAZIADA!');
     end
     else
         writeln(erros(1));

end;

//------------------------------------------------------------
// Procedure que Exibe o topo

procedure etopo(p : ponteiro);

begin
     if not(isPilVaz(p)) then
        writeln('Topo: ',p^.V)
     else
         writeln(erros(1));
end;

//------------------------------------------------------------
// Procedure que Imprime a Pilha

procedure prima(p : ponteiro);

var aux : ponteiro;

begin
     aux := p;
     if not(isPilVaz(p)) then
     while (aux <> nil) do begin
           writeln(aux^.V);
           aux := aux^.prox;
     end
     else
         writeln(erros(1));
end;


//------------------------------------------------------------
// Inico do Programa

begin
     Topo := nil;
     menu := 99;

while menu <> 0 do begin
      clrscr;
      writeln('(1) Push');
      writeln('(2) Pop');
      writeln('(3) Topo (etopo)');
      writeln('(4) Vazia? (isPilVaz)');
      writeln('(5) Esvaziar (EsvPil)');
      writeln('(6) Imprimir (prima)');
      writeln('(0) Sair');
      write('Menu -> ');
      readln(menu);

      case menu of
           1: begin clrscr; push(Topo); end;
           2: begin clrscr; pop(Topo); end;
           3: begin clrscr; etopo(topo); end;
           4: begin clrscr; if isPilVaz(Topo) then writeln(erros(1)) else writeln(erros(2)); end;
           5: begin clrscr; EsvPil(Topo); end;
           6: begin clrscr; prima(Topo); end;
      end;

      if menu <> 0 then
      readln;
  end;
end.
