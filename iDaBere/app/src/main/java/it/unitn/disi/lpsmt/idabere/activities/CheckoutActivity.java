package it.unitn.disi.lpsmt.idabere.activities;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MenuItem;
import android.widget.ExpandableListView;
import android.widget.TextView;
import android.widget.Toast;

import java.text.DecimalFormat;

import it.unitn.disi.lpsmt.idabere.DAOIntefaces.OrdersDAO;
import it.unitn.disi.lpsmt.idabere.R;
import it.unitn.disi.lpsmt.idabere.adapters.CheckoutExpandableListAdapter;
import it.unitn.disi.lpsmt.idabere.models.Customer;
import it.unitn.disi.lpsmt.idabere.models.Order;
import it.unitn.disi.lpsmt.idabere.session.AppSession;
import it.unitn.disi.lpsmt.idabere.utils.AppStatus;
import it.unitn.disi.lpsmt.idabere.utils.BackendConnection;


public class CheckoutActivity extends AppCompatActivity {

    private OrdersDAO ordersDAO;

    private Context mContext;

    private ExpandableListView mCheckoutExpandableListView;
    private CheckoutExpandableListAdapter mCheckoutListAdapter;
    private TextView totalOrderInfo;
    private TextView totalQuantity;
    private TextView deliveryType;
    private TextView paymentMethod;
    private TextView getDeliveryTypeDetails;

    private MenuItem sendDeliveryButton;

    private BottomNavigationView bottomNavigationView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkout);

        initViewComps();

        ordersDAO = WelcomeActivity.factoryDAO.newOrdersDAO();

        mContext = this;

        sendDeliveryButton = bottomNavigationView.getMenu().findItem(R.id.navigation_confirm_payment);

        bottomNavigationView.setOnNavigationItemSelectedListener(new BottomNavigationView.OnNavigationItemSelectedListener() {

            @Override
            public boolean onNavigationItemSelected(@NonNull MenuItem item) {
                boolean result = false;
                int itemId = item.getItemId();
                Intent intent = new Intent();

                switch (itemId) {
                    case R.id.navigation_payment_type:
                        CheckoutActivity.super.onBackPressed();
                        result = true;
                        break;

                    case R.id.navigation_confirm_payment:
                        if (isAuthenthicate() && AppStatus.getInstance(mContext).isOnline()){
                            Customer currentCustomer = AppSession.getInstance().getmCustomer();
                            Order currentOrder = currentCustomer.getOrder();

                            new SendOrderAsyncTask().execute(currentOrder,currentCustomer);
                        } else {
                            Toast.makeText(mContext, "Nessuna connessione dati attiva", Toast.LENGTH_SHORT).show();
                        }
                        result = true;
                        break;
                }
                return result;
            }

        });

        mCheckoutListAdapter = new CheckoutExpandableListAdapter(this, AppSession.getInstance().getmCustomer().getOrder());
        mCheckoutExpandableListView.setAdapter(mCheckoutListAdapter);

    }

    @Override
    protected void onResume() {
        Order currentOrder = AppSession.getInstance().getmCustomer().getOrder();
        totalOrderInfo.setText(new DecimalFormat("##0.00").format(currentOrder.getTotalPrice()));
        totalQuantity.setText(Integer.toString(currentOrder.getTotalQuantity()));
        deliveryType.setText(currentOrder.getChosenDeliveryPlace().getName());
        getDeliveryTypeDetails.setText(currentOrder.getChosenDeliveryPlace().toString());
        if(currentOrder.isUsingCreditCard()){
            paymentMethod.setText(currentOrder.getChosenCreditCard().toString());
        }
        else{
            paymentMethod.setText("CONTANTI");
        }

        mCheckoutListAdapter.notifyDataSetChanged();
        super.onResume();
    }

    private void initViewComps () {
        bottomNavigationView = (BottomNavigationView) findViewById(R.id.checkout_bottom_navigation);
        mCheckoutExpandableListView = (ExpandableListView) findViewById(R.id.checkout_list);
        totalOrderInfo = (TextView) findViewById(R.id.total_order_price);
        totalQuantity = (TextView) findViewById(R.id.total_items_quantity);
        deliveryType = (TextView) findViewById(R.id.delivery_type_choosen);
        paymentMethod = (TextView) findViewById(R.id.payment_method_choosen);
        getDeliveryTypeDetails = (TextView) findViewById(R.id.delivery_type_value);
    }

    private boolean isAuthenthicate () {
        boolean result = false;
        if (AppSession.getInstance().getmCustomer().getId() != -1) {
            result = true;
        } else {
            // Start Login activity for authentication
            Intent loginIntent = new Intent();
            loginIntent.setClass(mContext, LoginActivity.class);
            startActivity(loginIntent);
        }
        return result;
    }

    private class SendOrderAsyncTask extends AsyncTask<Object, Void, Order>{

        @Override
        protected void onPreExecute() {

            sendDeliveryButton.setEnabled(false);
            super.onPreExecute();
        }

        @Override
        protected Order doInBackground(Object... params) {
            Order result;

            result = ordersDAO.createOrder((Order)params[0], (Customer)params[1]);

            return result;
        }

        @Override
        protected void onPostExecute(Order retrievedOrder) {

            sendDeliveryButton.setEnabled(true);

            if (retrievedOrder != null) {
                Order currentOrder = AppSession.getInstance().getmCustomer().getOrder();
                currentOrder.setId(retrievedOrder.getId());
                currentOrder.setStatus(retrievedOrder.getStatus());
                currentOrder.setDestroyCode(retrievedOrder.getDestroyCode());
                Log.d("RETRIEVED ORDER", retrievedOrder.toString());
                Intent intent = new Intent();
                intent.setClass(mContext, OrderStatusActivity.class);
                startActivity(intent);
            } else {
                Toast.makeText(mContext, "Errore di sistema. Riprovare piu' tardi", Toast.LENGTH_SHORT).show();
            }

            super.onPostExecute(retrievedOrder);
        }
    }

}
