package it.unitn.disi.lpsmt.idabere.activities;

import android.Manifest;
import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Address;
import android.content.pm.PackageManager;
import android.location.Location;
import android.net.Uri;
import android.os.AsyncTask;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.SearchView;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.SearchEvent;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.Locale;

import android.widget.RelativeLayout;
import android.widget.Toast;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import it.unitn.disi.lpsmt.idabere.BuildConfig;
import it.unitn.disi.lpsmt.idabere.DAOIntefaces.FactoryDAO;
import it.unitn.disi.lpsmt.idabere.DAOInterfacesImpl.FactoryDAOImpl;
import it.unitn.disi.lpsmt.idabere.models.Bar;
import it.unitn.disi.lpsmt.idabere.R;
import it.unitn.disi.lpsmt.idabere.adapters.BarsArrayAdapter;
import it.unitn.disi.lpsmt.idabere.session.AppSession;
import it.unitn.disi.lpsmt.idabere.utils.AppStatus;
import it.unitn.disi.lpsmt.idabere.utils.NetworkStateReceiver;

public class ListBarActivity extends AppCompatActivity implements SearchView.OnQueryTextListener, NetworkStateReceiver.NetworkStateReceiverListener {

    private NetworkStateReceiver networkStateReceiver;

    private static final String TAG = ListBarActivity.class.getSimpleName();

    private static final int REQUEST_PERMISSIONS_REQUEST_CODE = 34;

    /**
     * Provides the entry point to the Fused Location Provider API.
     */
    private FusedLocationProviderClient mFusedLocationClient;

    /**
     * Represents a geographical location.
     */
    protected Location mLastLocation;

    private Context mContext;
    private ArrayList<Bar> barsList;

    /* Ui comps */

    private View loadingIndicator;
    private View errorConnectionLayout;
    private View serverErrorLayout;
    private View noDataErrorLayout;
    private ListView barsListView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_list_bar);
        initViewComps();
        AppSession appSession = AppSession.getInstance();
        if (    appSession.getmCustomer() != null &&
                appSession.getmCustomer().getOrder() != null &&
                appSession.getmCustomer().getOrder().getId() != -1){
            // Start order status activity to wait order to process
            Intent intent = new Intent();
            intent.setClass(this, OrderStatusActivity.class);
            startActivity(intent);
        }
        mContext = this;
        barsList = new ArrayList<Bar>();
        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        networkStateReceiver = new NetworkStateReceiver();
        networkStateReceiver.addListener(this);
        this.registerReceiver(networkStateReceiver, new IntentFilter(android.net.ConnectivityManager.CONNECTIVITY_ACTION));
        barsListView.setAdapter(new BarsArrayAdapter(mContext, R.layout.bar_list_item, barsList));

        barsListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                goToMenu(barsList.get(position).getId());
            }
        });

    }

    @Override
    protected void onStart() {
        showInfoElement(loadingIndicator.getId());

        if (AppStatus.getInstance(mContext).isOnline()) {
            if (!checkLocationPermissions()) {
                requestLocationPermissions();
            } else {
                getLastLocation();
            }
        } else {
            showInfoElement(errorConnectionLayout.getId());
            showSnackbar("Abilita una connessione dati per procedere");
            //Toast.makeText(mContext, "Nessuna Connessione", Toast.LENGTH_SHORT).show();
        }


        super.onStart();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult result = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        if(result != null) {
            if(result.getContents() == null) {
//                Toast.makeText(this, "Cancelled", Toast.LENGTH_LONG).show();
            } else {
                int scannedID = -1;
                try {
                    scannedID = Integer.parseInt(result.getContents());
                } catch (NumberFormatException ex){
                    ex.printStackTrace();
                }

                goToMenu(scannedID);
                //Toast.makeText(this, "Scanned: " + result.getContents(), Toast.LENGTH_LONG).show();
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    /**
     * menu bar methods
     **/

    // Inflate the menu into the activity layout
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.search_bar_menu, menu);

        // Get the SearchView and set the searchable configuration
        SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
        SearchView searchView = (SearchView) menu.findItem(R.id.action_search_bar_icon).getActionView();
        // Assumes current activity is the searchable activity
        searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));

        searchView.setSubmitButtonEnabled(false);
        searchView.setOnQueryTextListener(this);

        return super.onCreateOptionsMenu(menu);
    }

    // Handle menu action buttons click
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        boolean result = false;
        int itemId = item.getItemId();

        switch (itemId) {
            case R.id.action_qr_scanner_icon:

                IntentIntegrator integrator = new IntentIntegrator(this);
                integrator.setDesiredBarcodeFormats(IntentIntegrator.QR_CODE_TYPES);
                integrator.setBeepEnabled(false);
                integrator.setOrientationLocked(true);
                integrator.setPrompt("");
                integrator.initiateScan();
                result = true;
                break;
            case R.id.action_clear_search_bar_icon:
                result = true;
                break;
            case R.id.update_coordinates:
                this.onStart();
                break;
            default:
                result = super.onOptionsItemSelected(item);
        }

        return result;
    }

    /**
     * Class methods bar methods
     **/

    // This hook is called when the user signals the desire to start a search.
    public boolean onSearchRequested(SearchEvent seachEvent) {
        boolean result = false;
        return result;
    }


    public void goToMenu(int barId) {
        if (AppStatus.getInstance(mContext).isOnline()) {
            Intent intent = new Intent();
            intent.setClass(mContext, MenuActivity.class);

            Bar currentBar = AppSession.getInstance().getmBar();
            if (currentBar != null && currentBar.getId() != barId) {
                intent.putExtra("BAR_CHANGED", true);
            } else {
                intent.putExtra("BAR_CHANGED", false);
            }
            Bar tmp = new Bar();
            tmp.setId(barId);
            AppSession.getInstance().setmBar(tmp);
            startActivity(intent);
        } else {
            showSnackbar("E' necessaria una connessione dati abilitata");
//            Toast.makeText(mContext, "Impossible Connettersi", Toast.LENGTH_SHORT).show();
        }

    }

    @Override
    public boolean onQueryTextSubmit(String query) {
        return false;
    }

    @Override
    public boolean onQueryTextChange(String newText) {
        ((BarsArrayAdapter) barsListView.getAdapter()).getFilter().filter(newText);
        return true;
    }

    /**
     * Callback received when a permissions request has been completed.
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        Log.i(TAG, "onRequestPermissionResult");
        if (requestCode == REQUEST_PERMISSIONS_REQUEST_CODE) {
            if (grantResults.length <= 0) {
                // If user interaction was interrupted, the permission request is cancelled and you
                // receive empty arrays.
                Log.i(TAG, "User interaction was cancelled.");
            } else if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted.
                getLastLocation();
            } else {
                // Permission denied.

                // Notify the user via a SnackBar that they have rejected a core permission for the
                // app, which makes the Activity useless. In a real app, core permissions would
                // typically be best requested during a welcome-screen flow.

                // Additionally, it is important to remember that a permission might have been
                // rejected without asking the user for permission (device policy or "Never ask
                // again" prompts). Therefore, a user interface affordance is typically implemented
                // when permissions are denied. Otherwise, your app could appear unresponsive to
                // touches or interactions which have required permissions.
                showSnackbar(R.string.permission_denied_explanation, R.string.settings,
                        new View.OnClickListener() {
                            @Override
                            public void onClick(View view) {
                                // Build intent that displays the App settings screen.
                                Intent intent = new Intent();
                                intent.setAction(
                                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                                Uri uri = Uri.fromParts("package",
                                        BuildConfig.APPLICATION_ID, null);
                                intent.setData(uri);
                                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                startActivity(intent);
                            }
                        });
            }
        }
    }

    /**
     * Provides a simple way of getting a device's location and is well suited for
     * applications that do not require a fine-grained location and that do not need location
     * updates. Gets the best and most recent location currently available, which may be null
     * in rare cases when a location is not available.
     * <p>
     * Note: this method should be called after location permission has been granted.
     */
    @SuppressWarnings("MissingPermission")
    private void getLastLocation() {
        mFusedLocationClient.getLastLocation()
                .addOnCompleteListener(this, new OnCompleteListener<Location>() {
                    @Override
                    public void onComplete(@NonNull Task<Location> task) {
                        if (task.isSuccessful() && task.getResult() != null) {
                            mLastLocation = task.getResult();
                        } else {
                            Log.w(TAG, "getLastLocation:exception", task.getException());
                            showSnackbar(getString(R.string.no_location_detected));
                        }
                        new GpsLoader().execute();
                    }
                });
    }

    /**
     * Shows a {@link Snackbar} using {@code text}.
     *
     * @param text The Snackbar text.
     */
    private void showSnackbar(final String text) {
        View container = findViewById(R.id.main_activity_container);
        if (container != null) {
            Snackbar.make(container, text, Snackbar.LENGTH_LONG).show();
        }
    }

    /**
     * Shows a {@link Snackbar}.
     *
     * @param mainTextStringId The id for the string resource for the Snackbar text.
     * @param actionStringId   The text of the action item.
     * @param listener         The listener associated with the Snackbar action.
     */
    private void showSnackbar(final int mainTextStringId, final int actionStringId,
                              View.OnClickListener listener) {
        Snackbar.make(findViewById(android.R.id.content),
                getString(mainTextStringId),
                Snackbar.LENGTH_LONG)
                .setAction(getString(actionStringId), listener).show();
    }

    /**
     * Return the current state of the permissions needed.
     */
    private boolean checkLocationPermissions() {
        int permissionState = ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_COARSE_LOCATION);
        return permissionState == PackageManager.PERMISSION_GRANTED;
    }

    private void startLocationPermissionRequest() {
        ActivityCompat.requestPermissions(ListBarActivity.this,
                new String[]{Manifest.permission.ACCESS_FINE_LOCATION},
                REQUEST_PERMISSIONS_REQUEST_CODE);
    }

    private void requestLocationPermissions() {
        boolean shouldProvideRationale =
                ActivityCompat.shouldShowRequestPermissionRationale(this,
                        Manifest.permission.ACCESS_FINE_LOCATION);

        // Provide an additional rationale to the user. This would happen if the user denied the
        // request previously, but didn't check the "Don't ask again" checkbox.
        if (shouldProvideRationale) {
            Log.i(TAG, "Displaying permission rationale to provide additional context.");

            showSnackbar(R.string.gps_permission_rationale, android.R.string.ok,
                    new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            // Request permission
                            startLocationPermissionRequest();
                        }
                    });

        } else {
            Log.i(TAG, "Requesting permission");
            // Request permission. It's possible this can be auto answered if device policy
            // sets the permission in a given state or the user denied the permission
            // previously and checked "Never ask again".
            startLocationPermissionRequest();
        }
        new GpsLoader().execute();
    }

    @Override
    public void networkAvailable() {
        this.onStart();
    }

    @Override
    public void networkUnavailable() {
        this.onStart();
    }

    /**
     * Asynctask that retrieves all bars given the coordinates retrieved with the GPS
     */
    private class GpsLoader extends AsyncTask<Address, Void, ArrayList<Bar>> {

        @Override
        protected ArrayList<Bar> doInBackground(Address... params) {
            Address address = new Address(Locale.ITALIAN);
            if (mLastLocation != null) {
                Log.d("LOCATION", mLastLocation.toString());
                address.setLongitude(mLastLocation.getLongitude());
                address.setLatitude(mLastLocation.getLatitude());
                Log.d("ADDRESS", address.toString());
                barsList = WelcomeActivity.factoryDAO.newBarsDAO().getBarsByCoordinates(address);
            } else {
                barsList = WelcomeActivity.factoryDAO.newBarsDAO().getAllBars();
            }


            return barsList;
        }

        @Override
        protected void onPostExecute(ArrayList<Bar> bars) {

            ((BarsArrayAdapter) barsListView.getAdapter()).clear();

            if (bars != null) {
                if (bars.size() != 0) {
                    ((BarsArrayAdapter) barsListView.getAdapter()).addAll(bars);
                    showInfoElement(barsListView.getId());
                } else {
                    showInfoElement(noDataErrorLayout.getId());
                    //Toast.makeText(mContext, "Nessun dato disponibile", Toast.LENGTH_SHORT).show();
                }
            } else {
                showInfoElement(serverErrorLayout.getId());
                //Toast.makeText(mContext, "Errore. Riprovare piu' tardi", Toast.LENGTH_SHORT).show();
            }


            super.onPostExecute(bars);
        }

    }

    /**
     * UI elements methods
     **/

    // Instantiate layout elements
    private void initViewComps() {
        barsListView = (ListView) this.findViewById(R.id.bars_list_view);
        errorConnectionLayout = findViewById(R.id.no_connection_layout);
        loadingIndicator = findViewById(R.id.loading_indicator);
        serverErrorLayout = findViewById(R.id.server_error_layout);
        noDataErrorLayout = findViewById(R.id.no_data_error_layout);
    }

    private void showInfoElement(int resourceId) {

        switch (resourceId) {
            case R.id.loading_indicator :
                loadingIndicator.setVisibility(View.VISIBLE);
                barsListView.setVisibility(View.GONE);
                errorConnectionLayout.setVisibility(View.GONE);
                serverErrorLayout.setVisibility(View.GONE);
                noDataErrorLayout.setVisibility(View.GONE);
                break;
            case R.id.bars_list_view :
                loadingIndicator.setVisibility(View.GONE);
                barsListView.setVisibility(View.VISIBLE);
                errorConnectionLayout.setVisibility(View.GONE);
                serverErrorLayout.setVisibility(View.GONE);
                noDataErrorLayout.setVisibility(View.GONE);
                break;
            case R.id.no_connection_layout :
                loadingIndicator.setVisibility(View.GONE);
                barsListView.setVisibility(View.GONE);
                errorConnectionLayout.setVisibility(View.VISIBLE);
                serverErrorLayout.setVisibility(View.GONE);
                noDataErrorLayout.setVisibility(View.GONE);
                break;
            case R.id.server_error_layout :
                loadingIndicator.setVisibility(View.GONE);
                barsListView.setVisibility(View.GONE);
                errorConnectionLayout.setVisibility(View.GONE);
                serverErrorLayout.setVisibility(View.VISIBLE);
                noDataErrorLayout.setVisibility(View.GONE);
                break;
            case R.id.no_data_error_layout :
                loadingIndicator.setVisibility(View.GONE);
                barsListView.setVisibility(View.GONE);
                errorConnectionLayout.setVisibility(View.GONE);
                serverErrorLayout.setVisibility(View.GONE);
                noDataErrorLayout.setVisibility(View.VISIBLE);
                break;
        }

    }
}
