/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.unesp.rc.locadora.utils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author aluno
 */
public class DateManager {

    private DateManager() {
    }
    
    public static String formatte(Date dt){
        String pattern = "dd/MM/yyyy hh:mm:ss";
        
        DateFormat dft = new SimpleDateFormat(pattern);
        
        return dft.format(dt);
    }
}
