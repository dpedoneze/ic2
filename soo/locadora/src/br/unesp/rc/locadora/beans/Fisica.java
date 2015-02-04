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
public class Fisica extends Pessoa {

    private long cpf;

    public Fisica() {
    }

    public Fisica(long cpf, long idPessoa, String nome, Date dataNascimento) {
        super(idPessoa, nome, dataNascimento);
        this.cpf = cpf;
    }

    public long getCpf() {
        return cpf;
    }

    public void setCpf(long cpf) {
        this.cpf = cpf;
    }
}
