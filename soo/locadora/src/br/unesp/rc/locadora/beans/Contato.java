/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.beans;

/**
 *
 * @author aluno
 */
public class Contato {

    private long idContato;
    private String telefone;
    private String email;

    public Contato() {
    }

    public Contato(long idContato, String telefone, String email) {
        this.idContato = idContato;
        this.telefone = telefone;
        this.email = email;
    }

    /**
     * @return the idContato
     */
    public long getIdContato() {
        return idContato;
    }

    /**
     * @param idContato the idContato to set
     */
    public void setIdContato(long idContato) {
        this.idContato = idContato;
    }

    /**
     * @return the telefone
     */
    public String getTelefone() {
        return telefone;
    }

    /**
     * @param telefone the telefone to set
     */
    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    /**
     * @return the email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email the email to set
     */
    public void setEmail(String email) {
        this.email = email;
    }
}
