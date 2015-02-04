/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.beans;

import java.util.Date;

/**
 *
 * @author aluno
 */
public class Juridica extends Pessoa {

    private long cnpj;

    public Juridica() {
    }

    public Juridica(long cnpj, long idPessoa, String nome, Date dataNascimento) {
        super(idPessoa, nome, dataNascimento);
        this.cnpj = cnpj;
    }

    public long getCnpj() {
        return cnpj;
    }

    public void setCnpj(long cnpj) {
        this.cnpj = cnpj;
    }
}
