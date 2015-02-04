/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package locadorajavaintegral;

import br.unesp.rc.locadora.beans.Acesso;
import br.unesp.rc.locadora.beans.Contato;
import br.unesp.rc.locadora.beans.Endereco;
import br.unesp.rc.locadora.beans.Fisica;
import br.unesp.rc.locadora.dao.FisicaDAO;
import br.unesp.rc.locadora.dao.FisicaDAOImpl;
import br.unesp.rc.locadora.utils.FabricaConexao;
import java.sql.Connection;
import java.util.Date;

/**
 *
 * @author aluno
 */
public class LocadoraJAVAIntegral {

    public static void main(String[] args) {
//        Fisica f = new Fisica();
//        f.setNome("Harry Deitel");
//        f.setDataNascimento(new Date());
//        f.setCpf(123456789);
//        
//        Acesso a = new Acesso("harry", "deitel");
//        f.setAcesso(a);
//        
//        Contato c = new Contato(-1, "3333-4444", "harry@deitel.com");
//        f.setContato(c);
//        
//        Endereco e = new Endereco();
//        e.setRua("Rua 24A");
//        e.setNumero(1515);
//        e.setBairro("Bela Vista");
//        e.setCep(13575090);
//        e.setCidade("Rio Claro");
//        e.setEstado("SP");
//        f.setEndereco(e);
//        
//        FisicaDAO fdao = new FisicaDAOImpl();
//        fdao.print(f);
        
        Connection conexao = FabricaConexao.getConexao();
        
        if (conexao != null){
            System.out.println("CONECTADO!");
        } else {
            System.out.println("HOUVE ALGUM PROBLEMA AO CONECTAR!");
        }
        
    }
}
