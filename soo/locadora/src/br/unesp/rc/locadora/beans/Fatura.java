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
public class Fatura {

    private long idFatura;
    private float total;
    private String formaPagamento;
    private int numeroParcelas;
    /**
     * Este atributo representa o relacionamento bidirecional (1:*) de Fatura
     * para ItemFatura
     */
    private List<ItemFatura> itensFatura; // DIFERENTE!!!
    /**
     * Este atributo representa um relacionamento bidirecional (1:1) de Fatura
     * para Locacao
     */
    private Locacao locacao;

    public Fatura() {
        this.itensFatura = new ArrayList<ItemFatura>();
    }

    public Fatura(long idFatura, float total, String formaPagamento, int numeroParcelas) {
        this.idFatura = idFatura;
        this.total = total;
        this.formaPagamento = formaPagamento;
        this.numeroParcelas = numeroParcelas;
    }

    /**
     * @return the idFatura
     */
    public long getIdFatura() {
        return idFatura;
    }

    /**
     * @param idFatura the idFatura to set
     */
    public void setIdFatura(long idFatura) {
        this.idFatura = idFatura;
    }

    /**
     * @return the total
     */
    public float getTotal() {
        return total;
    }

    /**
     * @param total the total to set
     */
    public void setTotal(float total) {
        this.total = total;
    }

    /**
     * @return the formaPagamento
     */
    public String getFormaPagamento() {
        return formaPagamento;
    }

    /**
     * @param formaPagamento the formaPagamento to set
     */
    public void setFormaPagamento(String formaPagamento) {
        this.formaPagamento = formaPagamento;
    }

    /**
     * @return the numeroParcelas
     */
    public int getNumeroParcelas() {
        return numeroParcelas;
    }

    /**
     * @param numeroParcelas the numeroParcelas to set
     */
    public void setNumeroParcelas(int numeroParcelas) {
        this.numeroParcelas = numeroParcelas;
    }

    /**
     * @return the itensFatura
     */
    public List<ItemFatura> getItensFatura() {
        return itensFatura;
    }

    /**
     * @param itensFatura the itensFatura to set
     */
    public void setItensFatura(List<ItemFatura> itensFatura) {
        this.itensFatura = itensFatura;
    }

    public void setItensFatura(ItemFatura ift) {
        this.itensFatura.add(ift);
    }

    /**
     * @return the locacao
     */
    public Locacao getLocacao() {
        return locacao;
    }

    /**
     * @param locacao the locacao to set
     */
    public void setLocacao(Locacao locacao) {
        this.locacao = locacao;
    }
}
