package it.unitn.disi.lpsmt.idabere.models;

import com.google.gson.annotations.SerializedName;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by giovanni on 15/05/2017.
 */

public class Order {

    // TODO Modellazione della posizione in coda
    // TODO Modellazione del creation date
    private int id;

    private String status;
    private boolean isPaid;
    private ArrayList<OrderItem> orderItems;
    private double totalPrice;
    private int totalQuantity;
    private DeliveryPlace chosenDeliveryPlace;
    private boolean usingCreditCard;
    private CreditCard chosenCreditCard;
    private int chosenBarId;
    private String creationDate;
    public String destroyCode;

    public Order(){
        id = -1;
        isPaid = false;
        orderItems = new ArrayList<>();
    }
    public Order(int id, boolean isPaid, ArrayList<OrderItem> orderItems) {
        this.id = id;
        this.isPaid = isPaid;
        this.orderItems = orderItems;
    }

    public BarMenu getOrderMenuForReview(){
        ArrayList<BarMenuItem> barMenuItemsOfOrder = new ArrayList<>();
        for(OrderItem orderItem: orderItems){
            if(!barMenuItemsOfOrder.contains(orderItem.getBarMenuItem())){
                barMenuItemsOfOrder.add(orderItem.getBarMenuItem());
            }
        }
        return new BarMenu(barMenuItemsOfOrder);

    }


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean isPaid() {
        return isPaid;
    }

    public void setPaid(boolean isPaid) {
        this.isPaid = isPaid;
    }

    public ArrayList<OrderItem> getOrderItems() {
        return orderItems;
    }

    public void setOrderItems(ArrayList<OrderItem> orderItems) {
        this.orderItems = orderItems;
    }

    public double getTotalPrice() {return totalPrice;}

    public void setTotalPrice(double totalPrice) {this.totalPrice = totalPrice;}

    public DeliveryPlace getChosenDeliveryPlace() {
        return chosenDeliveryPlace;
    }

    public void setChosenDeliveryPlace(DeliveryPlace chosenDeliveryPlace) {
        this.chosenDeliveryPlace = chosenDeliveryPlace;
    }

    public boolean isUsingCreditCard() {
        return usingCreditCard;
    }

    public void setUsingCreditCard(boolean usingCreditCard) {
        this.usingCreditCard = usingCreditCard;
    }

    public CreditCard getChosenCreditCard() {
        return chosenCreditCard;
    }

    public void setChosenCreditCard(CreditCard chosenCreditCard) {
        this.chosenCreditCard = chosenCreditCard;
    }

    public String getCreationDate() {
        return creationDate;
    }

    public String getDestroyCode() {
        return destroyCode;
    }

    public void setDestroyCode(String destroyCode) {
        this.destroyCode = destroyCode;
    }

    public void setCreationDate(Date creationDate) {
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        this.creationDate = df.format(creationDate);
    }

    public int getChosenBarId() {
        return chosenBarId;
    }

    public void setChosenBarId(int chosenBarId) {
        this.chosenBarId = chosenBarId;
    }


    public void calculateTotalPrice() {
        double total = 0;
        for (OrderItem orderItem : orderItems){
            total += (orderItem.getSingleItemPrice()*orderItem.getQuantity());
        }
        totalPrice = total;
    }

    public void calculateTotalItems() {
        int total = 0;
        for (OrderItem orderItem : orderItems) {
            total += (orderItem.getQuantity());
        }
        totalQuantity = total;
    }

    public ArrayList<OrderItem> getOrderListFromBarMenuItemId(int barMenuItemId){
        ArrayList<OrderItem> ordItems = new ArrayList<>();
        for(OrderItem item: orderItems){
            if(item.getBarMenuItem().getId() == barMenuItemId){
                ordItems.add(item);
            }
        }
        return ordItems;
    }


    public OrderItem getExistentOrderItem(OrderItem newOrderItem) {
        ArrayList<OrderItem> possibleItems = getOrderListFromBarMenuItemId(newOrderItem.getBarMenuItem().getId());
        for(OrderItem orderItem:possibleItems){
            if(newOrderItem.equals(orderItem)){
                return orderItem;
            }
        }
        return null;
    }

    // Remove an order item from the order
    public int removeExistentOrderItem(OrderItem orderItem) {
        int result = -1;
        for (int i = 0; i < orderItems.size(); i++) {
            if(orderItem.equals(orderItems.get(i))){
                result = i;
            }
        }

        orderItems.remove(result);

        return result;
    }

    public double getTotalPriceByItemName (String itemName) {
        double result = 0;
        for (OrderItem item : orderItems) {
            if (item.getBarMenuItem().getName() == itemName){
                result += item.getSingleItemPrice()*item.getQuantity();
            }
        }
        return result;
    }

    @Override
    public String toString() {
        return "Order{" +
                "  \nid=" + id +
                ", \nisPaid=" + isPaid +
                ", \norderItems=" + orderItems +
                '}';
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }
}
