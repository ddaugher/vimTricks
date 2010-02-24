import sun.misc.BASE64Encoder;

import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.OutputStreamWriter;
import java.net.URLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Twitter {
    public static void main(String[] args) throws Exception {
        if (args.length < 3) {
            System.out.println("Twitter <userid> <password> <message>");
            System.exit(-1);
        }


    String serverName = "localhost";
    String mydatabase = "test";
    String dburl = "jdbc:mysql://" + serverName + ":8889/" + mydatabase; 
                                                                    
    String username = "root";
    String password = "root";
    Class.forName ("com.mysql.jdbc.Driver").newInstance ();
    Connection dbConnection = DriverManager.getConnection(dburl, username, password);

    String query = "select id, tip, nexttweet from vimtricks order by nexttweet limit 1";
    Statement stmt = dbConnection.createStatement();
    ResultSet rs = stmt.executeQuery(query);
    while (rs.next()) {
        int id = rs.getInt(1);
        String tip = rs.getString(2);
        int nexttweet = rs.getInt(3);
        System.out.println("id=" + id);
        System.out.println("tip=" + tip);
        System.out.println("nexttweet=" + nexttweet);
        System.out.println("---------------");
    }

        URL url = new URL("https://twitter.com/statuses/update.xml");
        URLConnection connection = url.openConnection();

        connection.setDoInput(true);
        connection.setDoOutput(true);
        connection.setUseCaches(false);

        String authorization = args[0] + ":" + args[1];
        BASE64Encoder encoder = new BASE64Encoder();
        String encoded = new String
                (encoder.encodeBuffer(authorization.getBytes())).trim();
        connection.setRequestProperty("Authorization", "Basic " + encoded);

        OutputStreamWriter out = new OutputStreamWriter(
                connection.getOutputStream());
        out.write("status=" + URLEncoder.encode(args[2], "UTF-8"));
        out.close();

        BufferedReader in = new BufferedReader(
                new InputStreamReader(
                        connection.getInputStream()));
        String response;
        while ((response = in.readLine()) != null) {
            System.out.println(response);
        }
        in.close();

    }
}
