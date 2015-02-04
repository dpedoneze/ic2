/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.beans;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author aluno
 */
public class Servico {

    private long idServico;
    private String descricao;
    private float preco;
    
    /**
     * Este atributo representa um relacionamento bidirecional (*:*) de Servico 
     * para Locacao
     */
    private List<Locacao> locacao = new ArrayList<Locacao>();

    public Servico() {
    }

    public Servico(long idServico, String descricao, float preco) {
        this.idServico = idServico;
        this.descricao = descricao;
        this.preco = preco;
    }

    /**
     * @return the idServico
     */
    public long getIdServico() {
        return idServico;
    }

    /**
     * @param idServico the idServico to set
     */
    public void setIdServico(long idServico) {
        this.idServico = idServico;
    }

    /**
     * @return the descricao
     */
    public String getDescricao() {
        return descricao;
    }

    /**
     * @param descricao the descricao to set
     */
    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    /**
     * @return the preco
     */
    public float getPreco() {
        return preco;
    }

    /**
     * @param preco the preco to set
     */
    public void setPreco(float preco) {
        this.preco = preco;
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
