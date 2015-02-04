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
public class Categoria {

    private long idCategoria;
    private String descricao;
    private float precoDiario;
    private float precoKmRodado;
    /**
     * Este atributo representa um relacionamento
     * bidirecional (1:*) de Categoria para Carro
     */
    private List<Carro> carros = new ArrayList<Carro>();

    public Categoria() {
    }

    public Categoria(long idCategoria, String descricao, float precoDiario, float precoKmRodado) {
        this.idCategoria = idCategoria;
        this.descricao = descricao;
        this.precoDiario = precoDiario;
        this.precoKmRodado = precoKmRodado;
    }

    /**
     * @return the idCategoria
     */
    public long getIdCategoria() {
        return idCategoria;
    }

    /**
     * @param idCategoria the idCategoria to set
     */
    public void setIdCategoria(long idCategoria) {
        this.idCategoria = idCategoria;
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
     * @return the precoDiario
     */
    public float getPrecoDiario() {
        return precoDiario;
    }

    /**
     * @param precoDiario the precoDiario to set
     */
    public void setPrecoDiario(float precoDiario) {
        this.precoDiario = precoDiario;
    }

    /**
     * @return the precoKmRodado
     */
    public float getPrecoKmRodado() {
        return precoKmRodado;
    }

    /**
     * @param precoKmRodado the precoKmRodado to set
     */
    public void setPrecoKmRodado(float precoKmRodado) {
        this.precoKmRodado = precoKmRodado;
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
}
