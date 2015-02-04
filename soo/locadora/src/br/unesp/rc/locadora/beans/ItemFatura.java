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
public class ItemFatura {

    private long idItemFatura;
    private float valor;
    private Date dataVencimento;
    private Date dataPagamento;    

    public ItemFatura() {
    }

    public ItemFatura(long idItemFatura, float valor, Date dataVencimento, Date dataPagamento) {
        this.idItemFatura = idItemFatura;
        this.valor = valor;
        this.dataVencimento = dataVencimento;
        this.dataPagamento = dataPagamento;
    }

    /**
     * @return the idItemFatura
     */
    public long getIdItemFatura() {
        return idItemFatura;
    }

    /**
     * @param idItemFatura the idItemFatura to set
     */
    public void setIdItemFatura(long idItemFatura) {
        this.idItemFatura = idItemFatura;
    }

    /**
     * @return the valor
     */
    public float getValor() {
        return valor;
    }

    /**
     * @param valor the valor to set
     */
    public void setValor(float valor) {
        this.valor = valor;
    }

    /**
     * @return the dataVencimento
     */
    public Date getDataVencimento() {
        return dataVencimento;
    }

    /**
     * @param dataVencimento the dataVencimento to set
     */
    public void setDataVencimento(Date dataVencimento) {
        this.dataVencimento = dataVencimento;
    }

    /**
     * @return the dataPagamento
     */
    public Date getDataPagamento() {
        return dataPagamento;
    }

    /**
     * @param dataPagamento the dataPagamento to set
     */
    public void setDataPagamento(Date dataPagamento) {
        this.dataPagamento = dataPagamento;
    }    
}
