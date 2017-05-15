package it.unitn.disi.lpsmt.idabere.Models;

/**
 * Created by giovanni on 15/05/2017.
 */

public class Topping {

    private int id;
    private String name;
    private double price;

    public Topping(int id, String name, double price) {
        this.id = id;
        this.name = name;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}