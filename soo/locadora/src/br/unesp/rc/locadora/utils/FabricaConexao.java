/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author aluno
 */
public class FabricaConexao implements IMySQL {

    private FabricaConexao() {
    }

    public static Connection getConexao() {
        Connection con = null;

        try {
            Class.forName(DRIVER);
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException ex) {
            System.out.println("PROBLEMAS AO CARREGARO DRIVER!");
            System.out.println(ex.getMessage());
        } catch (SQLException ex) {
            System.out.println("PROBLEMAS AO SE CONECTAR!");
            System.out.println(ex.getMessage());
        }

        return con;
    }

    public static void fechar(Connection con) {
        try {
            con.close();
        } catch (SQLException ex) {
            System.out.println("PROBLEMAS AO FECHAR A CONEXAO!");
            System.out.println(ex.getMessage());
        }
    }
}
