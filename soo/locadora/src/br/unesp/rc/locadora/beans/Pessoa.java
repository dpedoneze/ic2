/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.beans;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Essa é a classe pessoa
 *
 * @author aluno
 */
public class Pessoa {

    /**
     * Este campo é utilizado para armazenar a chave primária da entidade pessoa
     * existente no banco de dados
     */
    private long idPessoa;
    private String nome;
    private Date dataNascimento;
    
    /**
     * Esse atributo representa o relacionamento unidirecional (1:1) de Pessoa
     * para Acesso
     */
    private Acesso acesso;
    /**
     * Esse atributo representa o relacionamento unidirecional (1:1) de Pessoa
     * para Contato
     */
    private Contato contato;
    
    /**
     * Esse atributo representa o relacionamento unidirecional (1:1) de Pessoa
     * para Endereco
     */
    private Endereco endereco;
    /**
     * Este atributo representa o relacionamento bidirecional (1:*) de Pessoa para 
     * Locacao
     */
    private List<Locacao> locacao = new ArrayList<Locacao>();

    public Pessoa() {
    }

    /**
     * Esse é o construtor com parâmetros
     *
     * @param idPessoa
     * @param nome
     * @param dataNascimento
     */
    public Pessoa(long idPessoa, String nome, Date dataNascimento) {
        this.idPessoa = idPessoa;
        this.nome = nome;
        this.dataNascimento = dataNascimento;
    }

    /**
     * @return the idPessoa
     */
    public long getIdPessoa() {
        return idPessoa;
    }

    /**
     * @param idPessoa the idPessoa to set
     */
    public void setIdPessoa(long idPessoa) {
        this.idPessoa = idPessoa;
    }

    /**
     * @return the nome
     */
    public String getNome() {
        return nome;
    }

    /**
     * @param nome the nome to set
     */
    public void setNome(String nome) {
        this.nome = nome;
    }

    /**
     * @return the dataNascimento
     */
    public Date getDataNascimento() {
        return dataNascimento;
    }

    /**
     * @param dataNascimento the dataNascimento to set
     */
    public void setDataNascimento(Date dataNascimento) {
        this.dataNascimento = dataNascimento;
    }

    /**
     * @return the acesso
     */
    public Acesso getAcesso() {
        return acesso;
    }

    /**
     * @param acesso the acesso to set
     */
    public void setAcesso(Acesso acesso) {
        this.acesso = acesso;
    }

    /**
     * @return the contato
     */
    public Contato getContato() {
        return contato;
    }

    /**
     * @param contato the contato to set
     */
    public void setContato(Contato contato) {
        this.contato = contato;
    }

    /**
     * @return the endereco
     */
    public Endereco getEndereco() {
        return endereco;
    }

    /**
     * @param endereco the endereco to set
     */
    public void setEndereco(Endereco endereco) {
        this.endereco = endereco;
    }

    /**
     * @return the locacao
     */
    public List<Locacao> getLocacao() {
        return locacao;
    }

    /**
     * @param locacao the locacao to set
     */
    public void setLocacao(List<Locacao> locacao) {
        this.locacao = locacao;
    }
    
    public void setLocacao(Locacao loc) {
        this.locacao.add(loc);
    }
}
