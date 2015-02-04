/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.beans;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author aluno
 */
public class Locacao {

    private long idLocacao;
    private Date dataHoraRetirada;
    private Date dataHoraDevolucao;
    /**
     * Este atributo representa o relacionamento bidirecional (*:1) de Locacao
     * para Pessoa
     */
    private Pessoa pessoa;
    /**
     * Este atributo representa um relacionamento bidirecional (*:*) de Locacao
     * para Servico
     */
    private List<Servico> servico = new ArrayList<Servico>();
    /**
     * Este atributo representa um relacionamento bidirecional (*:*) de Locacao
     * para Carro
     */
    private List<Carro> carros = new ArrayList<Carro>();
    /**
     * Este atributo representa um relacionamento bidirecional (1:1) de Locacao
     * para Fatura
     */
    private Fatura fatura;

    public Locacao() {
    }

    public Locacao(long idLocacao, Date dataHoraRetirada, Date dataHoraDevolucao) {
        this.idLocacao = idLocacao;
        this.dataHoraRetirada = dataHoraRetirada;
        this.dataHoraDevolucao = dataHoraDevolucao;
    }

    /**
     * @return the idLocacao
     */
    public long getIdLocacao() {
        return idLocacao;
    }

    /**
     * @param idLocacao the idLocacao to set
     */
    public void setIdLocacao(long idLocacao) {
        this.idLocacao = idLocacao;
    }

    /**
     * @return the dataHoraRetirada
     */
    public Date getDataHoraRetirada() {
        return dataHoraRetirada;
    }

    /**
     * @param dataHoraRetirada the dataHoraRetirada to set
     */
    public void setDataHoraRetirada(Date dataHoraRetirada) {
        this.dataHoraRetirada = dataHoraRetirada;
    }

    /**
     * @return the dataHoraDevolucao
     */
    public Date getDataHoraDevolucao() {
        return dataHoraDevolucao;
    }

    /**
     * @param dataHoraDevolucao the dataHoraDevolucao to set
     */
    public void setDataHoraDevolucao(Date dataHoraDevolucao) {
        this.dataHoraDevolucao = dataHoraDevolucao;
    }

    /**
     * @return the pessoa
     */
    public Pessoa getPessoa() {
        return pessoa;
    }

    /**
     * @param pessoa the pessoa to set
     */
    public void setPessoa(Pessoa pessoa) {
        this.pessoa = pessoa;
    }

    /**
     * @return the servico
     */
    public List<Servico> getServico() {
        return servico;
    }

    /**
     * @param servico the servico to set
     */
    public void setServico(List<Servico> servico) {
        this.servico = servico;
    }

    public void setServico(Servico serv) {
        this.servico.add(serv);
    }

    /**
     * @return the carros
     */
    public List<Carro> getCarros() {
        return carros;
    }

    /**
     * @param carros the carros to set
     */
    public void setCarros(List<Carro> carros) {
        this.carros = carros;
    }

    public void setCarros(Carro car) {
        this.carros.add(car);
    }

    /**
     * @return the fatura
     */
    public Fatura getFatura() {
        return fatura;
    }

    /**
     * @param fatura the fatura to set
     */
    public void setFatura(Fatura fatura) {
        this.fatura = fatura;
    }
}
