C       Alunos
C         David Asbahr Pedoneze
C         Haroldo Leite
C
CC        maximo de 667 processos de 30 ms em 20 segundos de teste!
CC        pensando nisso foi setado a variavel FIM com 668 para que
CC        sejam gerados 667 processos na lista!

        real*8 rnum,PMOD,DMAX,num,a1,b1,a2,b2,l
        real*8 proc,c1,c2,k,filaAux,tempoAux,tempototal
        real*8 w,totalp1,totalp2,totalp,fim,tp1,tp2
        real*8 tec(10000),tr(10000),ti(10000),tf(10000)
        real*8 fila(10000),filaord(10000),tempo(10000),ts(10000)
        integer iseed,z

        PMOD = 2147483647.d0
        DMAX = 10d0/PMOD

CC      FIM = numero de vezes que ira rodar o simulador
CC      a e b sao os limites de tempo em ms
        fim = 668
        proc = 999
        c1 = 0
        c2 = 0
        a1 = 30
        b1 = 80
        a2 = 80
        b2 = 300
        tp1 = 0
        tp2 = 0
        
      DO i=2,fim
CC         para aumentar o random do iseed
           iseed = 80000*i+1500
           rnum = cong(iseed)
           
CC         Verifica se o processo eh Classe1 ou Classe2
           if((rnum.gt.0d0) .AND. (rnum.le.0.3d0)) then
                fila(i) = 2
CC              gera tempo classe 2 (de 80 a 300)
                tempo(i) = a2+(b2-a2)*rnum
           else
                fila(i) = 1
                tempo(i) = a1+(b1-a1)*rnum
           end if
        end do

CC      conta quantos processos C1 e C2 tem
      DO e=2,fim
         if(fila(e).eq.2) then
            tp2 = tp2 + 1
         end if
      end do
      
      
CC     Para ordenar os processos 111211121112...2
      c1 = 0
      DO j=2,fim
CC       Se o processo for classe 1, soma +1 em c1
         if(fila(j).eq.1) then
            c1 = c1 + 1
         end if
CC       se o processo for classe 2 e os processos classe 1 passados
CC       forem menor ou igual a 2
         if((fila(j).eq.2).and.(c1.le.2)) then
             z = j
CC           procura na fila pelo proximo processo classe 1
             do while((fila(z).ne.1).and.(z.le.fim))
                 z = z + 1
             end do
CC           Se nao atingir o fim da fila sem encontrar nenhum
             if(z.le.fim) then
CC              efetua a troca do processo classe 1 encontrado
CC              pelo processo classe 2 (atual)
                filaAux = fila(j)
                fila(j) = fila(z)
                fila(z) = filaAux

                tempoAux = tempo(j)
                tempo(j) = tempo(z)
                tempo(z) = tempoAux
                c1 = c1 + 1
             end if
         else
CC           Caso o processo seja classe 2 mas ja tenha 3 classe 1
             if((fila(j).eq.2).and.(c1.ge.3)) then
CC               mantem o processo classe 2 na mesma posicao
CC               e zera o contador de processos classe 1
                 c1 = 0
              end if
         end if
      end do


      tempototal = 0
      totalp1 = 0
      totalp2 = 0
      totalp = 0
      w = 2
CC    enquanto tempo total de processamento for menor ou igual a 20seg
CC    1s = 1.000ms 20s = 20.000
      do while(tempototal.le.20000)
CC       soma o tempo do processo
         tempototal = tempototal + tempo(w) + 0.10
CC       zera o tempo do processo (ja computado)
         tempo(w) = 0
CC       verifica qual classe Ç o processo
         if(fila(w).eq.1) then
             totalp1 = totalp1 + 1
         else
             totalp2 = totalp2 + 1
         end if
         w = w + 1
      end do

CC    soma total processos computados
      totalp = totalp1 + totalp2
      tp1 = fim-tp2

90    FORMAT('Total de processos em fila:       ',F4.0)
      write(*,100)fim
100   FORMAT('Total de processos computados:    ',F4.0)
      write(*,100)totalp
119   FORMAT('Total de processos C1 em fila:    ',F4.0)
      write(*,119)tp1
110   FORMAT('Total de processos C1 computados: ',F4.0)
      write(*,110)totalp1
12    FORMAT('Total de processos C2 em fila:    ',F4.0)
      write(*,12)tp2
120   FORMAT('Total de processos C2 computados: ',F4.0)
      write(*,120)totalp2

      read(*,16)a
16    format(f4.0)
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
