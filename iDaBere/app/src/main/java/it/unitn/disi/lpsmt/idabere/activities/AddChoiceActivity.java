package it.unitn.disi.lpsmt.idabere.activities;

import android.content.Context;
import android.content.Intent;
import android.graphics.Paint;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.Toast;

import java.text.DecimalFormat;
import java.util.ArrayList;

import it.unitn.disi.lpsmt.idabere.R;
import it.unitn.disi.lpsmt.idabere.adapters.AdditionListArrayListAdapter;
import it.unitn.disi.lpsmt.idabere.adapters.MenuCategoryExpandableListAdapter;
import it.unitn.disi.lpsmt.idabere.models.Addition;
import it.unitn.disi.lpsmt.idabere.models.BarMenuItem;
import it.unitn.disi.lpsmt.idabere.models.Customer;
import it.unitn.disi.lpsmt.idabere.models.Order;
import it.unitn.disi.lpsmt.idabere.models.OrderItem;
import it.unitn.disi.lpsmt.idabere.models.Size;
import it.unitn.disi.lpsmt.idabere.session.AppSession;
import it.unitn.disi.lpsmt.idabere.utils.MyRadioGroup;

public class AddChoiceActivity extends AppCompatActivity {

    public static final int RESULT_QUANTITY_PLUS_1 = 111111111;
    public static final int RESULT_ERROR = 222222;
    static final private int SELECT_NEW_CHOICE_REQUEST = 1;

    private boolean hasDiscount;

    private Button addChoiceButton;
    private Button cancelChoiceButton;


    private ListView additionListView;
    private LinearLayout sizesLinearLayout; //TODO CAMBIA TUTTA LA LOGICA DEL RADIO GROUP AL MyRadioGroup
    private MyRadioGroup sizeRadioGroup;
    private TextView pricePreview;
    private TextView menuItemNameTv;
    private TextView menuItemDiscountTv;

    private AdditionListArrayListAdapter additionListArrayListAdapter;



    BarMenuItem mBarMenuItem;
    // Fake data variables
    private final String UNIT_MEASURE = "cl";
    private ArrayList<String> SIZE_LIST;
    private ArrayList<String> ADDITION_LIST;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_add_choice);
        sizesLinearLayout = (LinearLayout) findViewById(R.id.sizes_linear_layout);
        additionListView = (ListView) findViewById(R.id.additions_list_view);
        pricePreview = (TextView) findViewById(R.id.choice_preview_price);
        menuItemNameTv = (TextView) findViewById(R.id.menu_item_name_tv);
        menuItemDiscountTv = (TextView) findViewById(R.id.menu_item_discount_tv);
        sizeRadioGroup = new MyRadioGroup();
        sizesLinearLayout = (LinearLayout) findViewById(R.id.sizes_linear_layout);

        /* ***GET THE BAR_MENU_ITEM SELECTED*** */
        int itemId = this.getIntent().getIntExtra("barMenuItemId",-1);
        mBarMenuItem = AppSession.getInstance().getmBar().getBarMenu().getBarMenuItemFromId(itemId);
        if(mBarMenuItem == null){
            System.out.println("\n\nERRORE, NESSUN BAR_MENU_ITEM CON id=" + itemId +"\n\n");
            setResult(RESULT_CANCELED);
            finish();
        }
        /* ************************************* */



        /* *** BUTTONS CONFIGURATION *** */
        addChoiceButton = (Button) findViewById(R.id.add_choice_button);
        cancelChoiceButton = (Button) findViewById(R.id.cancel_chioce_button);

        addChoiceButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //CREO L'OrderItem CON LE SCELTE DELL'UTENTE
                OrderItem newOrderItem = createNewOrderItemFromUserInput();

                //AGGIUNGO IL NUOVO ITEM ALL'ORDINE
                int result = addOrderItemToSessionOrder(newOrderItem);

                //INVIO ALL'ACTIVITY RICHIEDENTE SE L'OPERAZIONE È ANDATA O NO A BUON FINE
                switch (result) {
                    case RESULT_OK:
                        setResult(RESULT_OK);
                        break;
                    case RESULT_QUANTITY_PLUS_1:
                        setResult(RESULT_QUANTITY_PLUS_1);
                        break;
                    case RESULT_ERROR:
                        setResult(RESULT_ERROR);
                        break;
                    default:
                        setResult(RESULT_CANCELED);
                        break;
                }
                finish();
            }
        });

        cancelChoiceButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setResult(RESULT_CANCELED);
                finish();
            }
        });
        /* ***************************** */

        /* *** CONTENT'S VIEW CREATION *** */
        menuItemNameTv.setText(mBarMenuItem.getName());

        this.hasDiscount = false;
        if (mBarMenuItem.getDiscount() != null){
            if (mBarMenuItem.getDiscount() != 0){
                this.hasDiscount = true;
            }
        }

        if (this.hasDiscount){
            menuItemDiscountTv.setVisibility(View.VISIBLE);
            menuItemDiscountTv.setText("-"+new DecimalFormat("##").format(mBarMenuItem.getDiscount())+"%");
        } else {
            menuItemDiscountTv.setVisibility(View.GONE);
        }

        displaySizesList();


        if(mBarMenuItem.getAdditions() != null) {
            additionListArrayListAdapter = new AdditionListArrayListAdapter(this, R.layout.addition_choice, mBarMenuItem.getAdditions());
            additionListView.setAdapter(additionListArrayListAdapter);
        }
        else{
            TextView additionsLabel = (TextView)findViewById(R.id.additions_title_label);
            additionsLabel.setText("");
        }
        updatePreview();
        /* ******************************* */

    }

    private void displaySizesList () {
        LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        for (int i = 0; i < mBarMenuItem.getSizes().size(); i++) {

            View choiceSizeView = layoutInflater.inflate(R.layout.size_choice,null);
            RadioButton button = (RadioButton) choiceSizeView.findViewById(R.id.choice_size_rb);
            TextView newPriceTextView = (TextView) choiceSizeView.findViewById(R.id.size_price_label);
            TextView oldPriceTextView = (TextView) choiceSizeView.findViewById(R.id.price_old);
            TextView oldCurrencyTextView = (TextView) choiceSizeView.findViewById(R.id.currency_old);

            button.setId(i);
            button.setText(mBarMenuItem.getSizes().get(i).getName());

            newPriceTextView.setText(new DecimalFormat("##0.00").format(mBarMenuItem.getSizes().get(i).getPrice()));

            if (this.hasDiscount){
                oldPriceTextView.setText(new DecimalFormat("##0.00").format(mBarMenuItem.getSizes().get(i).getOriginalPrice()));
                oldPriceTextView.setVisibility(View.VISIBLE);
                oldCurrencyTextView.setVisibility(View.VISIBLE);
                oldPriceTextView.setPaintFlags(oldPriceTextView.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
                oldCurrencyTextView.setPaintFlags(oldCurrencyTextView.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
            } else {
                oldPriceTextView.setVisibility(View.GONE);
                oldCurrencyTextView.setVisibility(View.GONE);
            }

            sizesLinearLayout.addView(choiceSizeView);
            sizeRadioGroup.add(button);
        }

        sizeRadioGroup.initialize();
        sizeRadioGroup.addOnCheckedElementChangeListener(new MyRadioGroup.OnCheckedElementChangeListener() {
            @Override
            public void onCheckedElementChange(MyRadioGroup.CheckedElementChangeEvent event) {
                Log.d("BBBBBBBBBBBBBBBBBB", "event" + event.isChanged());
                if(event.isChanged()) {
                    updatePreview();
                }
            }
        });

    }

    public static void checkNewChoiceResult(int requestCode, int resultCode, Intent data, Context context,MenuCategoryExpandableListAdapter menuAdapter){
        if(requestCode == SELECT_NEW_CHOICE_REQUEST){
            switch(resultCode) {
                case RESULT_OK:
                    menuAdapter.notifyDataSetChanged();
                    Toast.makeText(context.getApplicationContext(),"Scelta aggiunta",Toast.LENGTH_SHORT).show();
                    break;
                case AddChoiceActivity.RESULT_QUANTITY_PLUS_1:
                    Toast.makeText(context.getApplicationContext(),"Scelta già esitente, quantità incrementata",Toast.LENGTH_SHORT).show();
                    menuAdapter.notifyDataSetChanged();
                    break;
                case AddChoiceActivity.RESULT_ERROR:
                    Toast.makeText(context.getApplicationContext(),"C'è stato un errore nell'aggiunta dell'item",Toast.LENGTH_SHORT).show();
                    break;
                default:
                    break;
            }

        }
    }


    public void updatePreview(){
        OrderItem tempOrderItem = createNewOrderItemFromUserInput();
        pricePreview.setText(new DecimalFormat("##0.00").format(tempOrderItem.getSingleItemPrice()));
    }

    OrderItem createNewOrderItemFromUserInput(){
        //PRENDO LA LISTA DI ID DELLE ADDITIONS E L'ID DELLA SIZE
        ArrayList<Integer> selectedAdditionsIds = new ArrayList<Integer>();
        if(mBarMenuItem.getAdditions() != null) {
            selectedAdditionsIds = new ArrayList<Integer> (((AdditionListArrayListAdapter)additionListView.getAdapter()).getSelectedAdditionsIds());
        }
        int chosenSizeId = mBarMenuItem.getSizes().get(sizeRadioGroup.getCurrentCheckedButton().getId()).getId();

        System.out.println("chosenAdditionsIds" + selectedAdditionsIds);
        System.out.println("chosenSizeId" + chosenSizeId);


        if(chosenSizeId != -1){ //gli id sono passati correttamente

            int quantity = 1;
            Size chosenSize = mBarMenuItem.getSizeFromId(chosenSizeId);
            ArrayList<Addition> chosenAdditions = new ArrayList<>();
            for(Integer additionId: selectedAdditionsIds){
                chosenAdditions.add(mBarMenuItem.getAdditionFromId(additionId));
            }
            double newSingleItemPrice = chosenSize.getPrice();
            for(Addition a: chosenAdditions){
                newSingleItemPrice += a.getPrice();
            }

            OrderItem newOrderItem = new OrderItem(
                    quantity,
                    newSingleItemPrice,
                    chosenSize,
                    chosenAdditions,
                    mBarMenuItem
            );

            return newOrderItem;
        }
        else{
            Toast.makeText(this,"ERROR: ERRORE NELLA CREAZIONE DELL'ORDINE", Toast.LENGTH_LONG).show();
        }
        return null;

    }

    int addOrderItemToSessionOrder(OrderItem newOrderItem){
        if(newOrderItem != null) {
            OrderItem existentOrderItem = AppSession.getInstance().getmCustomer().getOrder().getExistentOrderItem(newOrderItem);
            if (existentOrderItem == null) {
                Customer customer = AppSession.getInstance().getmCustomer();
                Order userOrder = customer.getOrder();
                userOrder.getOrderItems().add(newOrderItem);
                /*
                int i = 0;
                for (OrderItem orderItem : AppSession.getInstance().getmCustomer().getOrder().getOrderItems()) {
                    String description = orderItem.getSize().getName();
                    for (Addition a : orderItem.getAdditions()) {
                        description += ", " + a.getName();
                    }
                    Log.d("ORDER Item" + i, description);
                    i++;

                }*/
                return RESULT_OK;
            } else {
                existentOrderItem.setQuantity(existentOrderItem.getQuantity() + 1);
                return RESULT_QUANTITY_PLUS_1;
            }
        }else{
            return RESULT_ERROR;
        }
    }
}
