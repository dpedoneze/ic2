CC      Simular o andar de um motorista bebado
CC        Saiu de uma festa (madrugada)
CC        1) Inicio coordenada (0,0)
CC        2) Vive na esquina cujas coordenadas s∆o (5,4) direá∆o nordeste
CC        3) Leva 1 minuto para percorrer uma quadra
CC        4) Ao chegar em uma esquina se determ 1 minuto, em mÇdia, para pausas
CC        5) Caso ele veja uma viatura da policia ele estaciona e aguarda 10 min, em mÇdia
CC        6) Estando em uma esquina, a probabilidade de ele tomar a direá∆o:
CC           leste > 35%
CC           norte > 45%
CC           sul   > 10%
CC           oeste > 10%
CC       7) A probabilidade de encontrar a pol°cia Ç de 1%
CC        8) A cidade possui traáado regular com ruas que possuem os dois sentidos

CC        Calcule a proporá∆o de vezes que ele chega em casa
CC           a) 10 minutos
CC           b) 20 minutos
CC           c) 01 hora

        real*8 rnum,pol,PMOD,DMAX,porcem
        integer iseed,x,y,tempoinf,sucesso,tempo,policia,iseed2

        PMOD = 2147483647.d0
        DMAX = 10d0/PMOD

      write(*,14)
14    FORMAT ('Informe o tempo (em min):')
      read(*,*)tempoinf

      sucesso = 0;
      policia = 0;

            
      do k=1,1000
      tempo = 0;
      x = 0;
      y = 0;
      iseed = k+1;
      do while(tempo < tempoinf)
           rnum = cong(iseed)

           if(rnum.le.0.45d0) then
               y = y + 1
           else if(rnum.gt.0.45d0 .AND. rnum.le.0.80d0) then
               x = x + 1
           else if(rnum.gt.0.80d0 .AND. rnum.le.0.90d0) then
               y = y - 1
           else
               x = x - 1
           end if

           tempo = tempo + 2;
           
          pol = cong(iseed+1)
           if(pol <= 0.01d0) then
               policia = policia + 1;
              tempo = tempo + 10;
           end if

           if(x == 5 .AND. y == 4) then
               sucesso = sucesso +1
               tempo = tempoinf
           end if
      end do
      end do

      print *, 'chegou ',sucesso,' vezes em 1k tentativas'
      print *, 'Encontrou a policia ',policia,' vezes'

      read(*,12)a
12    format(f4.0)
      end

        FUNCTION cong(iseed)
                 real*8 RMOD,PMOD,DMAX
                 integer issed,IMOD
                 RMOD = DFLOAT(iseed)
                 PMOD = 2147483647.0d0
                 DMAX = 1.0d0/PMOD
                 RMOD = RMOD*16807.d0
                 IMOD = RMOD * DMAX
                 RMOD = RMOD - PMOD*IMOD
                 cong = RMOD * DMAX
                 iseed = RMOD
                 RETURN
        end
