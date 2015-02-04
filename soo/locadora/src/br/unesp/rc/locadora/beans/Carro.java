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
public class Carro {

    private String placa;
    private String marca;
    private int ano;
    private float quilometragem;
    private boolean statusLocacao;
    private boolean statusPatrimonio;
    /**
     * Este atributo representa um relacionamento
     * bidirecional (*:*) de Carro para Locacao
     */
    private List<Locacao> locacao = new ArrayList<Locacao>();

    public Carro() {
    }

    public Carro(String placa, String marca, int ano, float quilometragem, boolean statusLocacao, boolean statusPatrimonio) {
        this.placa = placa;
        this.marca = marca;
        this.ano = ano;
        this.quilometragem = quilometragem;
        this.statusLocacao = statusLocacao;
        this.statusPatrimonio = statusPatrimonio;
    }

    /**
     * @return the placa
     */
    public String getPlaca() {
        return placa;
    }

    /**
     * @param placa the placa to set
     */
    public void setPlaca(String placa) {
        this.placa = placa;
    }

    /**
     * @return the marca
     */
    public String getMarca() {
        return marca;
    }

    /**
     * @param marca the marca to set
     */
    public void setMarca(String marca) {
        this.marca = marca;
    }

    /**
     * @return the ano
     */
    public int getAno() {
        return ano;
    }

    /**
     * @param ano the ano to set
     */
    public void setAno(int ano) {
        this.ano = ano;
    }

    /**
     * @return the quilometragem
     */
    public float getQuilometragem() {
        return quilometragem;
    }

    /**
     * @param quilometragem the quilometragem to set
     */
    public void setQuilometragem(float quilometragem) {
        this.quilometragem = quilometragem;
    }

    /**
     * @return the statusLocacao
     */
    public boolean isStatusLocacao() {
        return statusLocacao;
    }

    /**
     * @param statusLocacao the statusLocacao to set
     */
    public void setStatusLocacao(boolean statusLocacao) {
        this.statusLocacao = statusLocacao;
    }

    /**
     * @return the statusPatrimonio
     */
    public boolean isStatusPatrimonio() {
        return statusPatrimonio;
    }

    /**
     * @param statusPatrimonio the statusPatrimonio to set
     */
    public void setStatusPatrimonio(boolean statusPatrimonio) {
        this.statusPatrimonio = statusPatrimonio;
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
