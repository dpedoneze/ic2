/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.dao;

import br.unesp.rc.locadora.beans.Fisica;
import br.unesp.rc.locadora.utils.DateManager;

/**
 *
 * @author aluno
 */
public class FisicaDAOImpl implements FisicaDAO {

    public FisicaDAOImpl() {
    }
    
    @Override
    public void print(Fisica f){
        System.out.println("NOME....................: " + f.getNome());
        
        String date = DateManager.formatte(f.getDataNascimento());
        System.out.println("DATA DE NASCIMENTO......: " + date);
        
        
        System.out.println("CPF.....................: " + f.getCpf());
        System.out.println("USUARIO.................: " + f.getAcesso().getUsuario());
        System.out.println("SENHA...................: " + f.getAcesso().getSenha());
        System.out.println("TELEFONE................: " + f.getContato().getTelefone());
        System.out.println("E-MAIL..................: " + f.getContato().getEmail());
        System.out.println("RUA.....................: " + f.getEndereco().getRua());
        System.out.println("NUMERO..................: " + f.getEndereco().getNumero());
        System.out.println("BAIRRO..................: " + f.getEndereco().getBairro());
        System.out.println("CEP.....................: " + f.getEndereco().getCep());
        System.out.println("CIDADE..................: " + f.getEndereco().getCidade());
        System.out.println("ESTADO..................: " + f.getEndereco().getEstado());
    }
    
    public int oculto(){
        return 1;
    }
}
