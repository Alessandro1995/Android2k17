package it.unitn.disi.lpsmt.idabere.utils;

import android.content.Context;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.lang.reflect.Type;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


import javax.net.ssl.HttpsURLConnection;

import it.unitn.disi.lpsmt.idabere.activities.LoginActivity;
import it.unitn.disi.lpsmt.idabere.models.Bar;
import it.unitn.disi.lpsmt.idabere.models.TimeOpen;

/**
 * Created by giovanni on 22/06/2017.
 */

public class BackendConnection {

    private final int RESPONSE_OK = 200;

    public ArrayList<String> errors;

    private String BASE_URL;
    private ArrayList<String> ROUTES;
    private ArrayList<String> PARAMETERS;
    private ArrayList<String> PARAMETERS_VALUES;

    private Uri.Builder uriBuilder;

    private Uri builtUri;
    private URL builtURL;

    private void addError(String error) {
        if (getErrors() == null) {
            errors = new ArrayList<>();
        }
        errors.add(error);
    }

    private String getPostParametersAsString () {
        String result = "";
        int i;
        for (i = 0; i < PARAMETERS.size() -1; i++) {
            result += PARAMETERS.get(i) + "=" + PARAMETERS_VALUES.get(i) + "&";
        }
        result += PARAMETERS.get(i) + "=" + PARAMETERS_VALUES.get(i);
        return result;
    }

    private String readBuffer(HttpURLConnection urlConnection) {
        String result = "";
        BufferedReader in = null;
        try {
            in = new BufferedReader(
                    new InputStreamReader(urlConnection.getInputStream()));
        } catch (IOException e) {
            e.printStackTrace();
        }
        String inputLine;
        StringBuffer response = new StringBuffer();

        try {
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        result = response.toString();
        return result;
    }

    public void appendRoutes() {
        for (int i = 0; i < ROUTES.size(); i++) {
            uriBuilder.appendPath(ROUTES.get(i));
        }
    }

    public void appendQueryParametersGET() {
        for (int i = 0; i < PARAMETERS.size(); i++) {
            uriBuilder.appendQueryParameter(PARAMETERS.get(i), PARAMETERS_VALUES.get(i));
        }
    }

    public void buildUri() {
        builtUri = Uri.parse(BASE_URL);
        uriBuilder = builtUri.buildUpon();
    }

    public void buildURL() {
        builtUri = uriBuilder.build();
        builtURL = null;
        try {
            builtURL = new URL(builtUri.toString());
        } catch (MalformedURLException e) {
            addError("URL Malformato");
            e.printStackTrace();
        }
    }

    public String connectUrlPOST() {
        String data = "";

        String url = builtURL.toString();

        HttpURLConnection con = null;

        try {
            con = (HttpURLConnection) builtURL.openConnection();
        } catch (IOException e) {
            e.printStackTrace();
        }

        //add reuqest header
        try {
            con.setRequestMethod("POST");
        } catch (ProtocolException e) {
            e.printStackTrace();
        }

        //con.setRequestProperty("User-Agent", USER_AGENT);
        //con.setRequestProperty("Accept-Language", "en-US,en;q=0.5");

        String urlParameters = getPostParametersAsString();

        // Send post request
        con.setDoOutput(true);
        DataOutputStream wr = null;
        try {
            wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(urlParameters);
            wr.flush();
            wr.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        int responseCode = 0;
        try {
            responseCode = con.getResponseCode();
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("\nSending 'POST' request to URL : " + url);
        System.out.println("Post parameters : " + urlParameters);
        System.out.println("Response Code : " + responseCode);

        if (responseCode == RESPONSE_OK){
            data = readBuffer(con);
        }

        //print result
        System.out.println(data);

        return data;
    }


    public String connectUrlGET() {

        String data = "";

        HttpURLConnection urlConnection = null;
        try {
            urlConnection = (HttpURLConnection) builtURL.openConnection();
        } catch (IOException e) {
            addError("Errore di IO");
            e.printStackTrace();
        }

        data = readBuffer(urlConnection);

        return data;
    }

    public ArrayList<String> getErrors() {
        return errors;
    }


    public String getBASE_URL() {
        return BASE_URL;
    }

    public void setBASE_URL(@NonNull String BASE_URL) {
        if (BASE_URL != null || BASE_URL.isEmpty()) {
            this.BASE_URL = BASE_URL;
        } else {
            addError("Base URL Vuoto");
        }

    }

    public ArrayList<String> getROUTES() {
        return ROUTES;
    }

    public void setROUTES(ArrayList<String> ROUTES) {
        this.ROUTES = ROUTES;
    }

    public ArrayList<String> getPARAMETERS() {
        return PARAMETERS;
    }

    public void setPARAMETERS(ArrayList<String> PARAMETERS) {
        this.PARAMETERS = PARAMETERS;
    }

    public ArrayList<String> getPARAMETERS_VALUES() {
        return PARAMETERS_VALUES;
    }

    public void setPARAMETERS_VALUES(ArrayList<String> PARAMETERS_VALUES) {
        this.PARAMETERS_VALUES = PARAMETERS_VALUES;
    }
}
