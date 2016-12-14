import java.sql.*;

public class GestionCommande
{
  public static void ajouterClient (int cid, String nom, String prenom,
   String numAdr, String rue, String ville, String pays,String tel) throws SQLException
  {
    String sql = "INSERT INTO CLIENT VALUES (?,?,?,?,?,?,?,?)";
    try
    {
      Connection conn = DriverManager.getConnection("jdbc:default:connection:");
      PreparedStatement pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, cid);
      pstmt.setString(2, nom);
      pstmt.setString(3, prenom);
      pstmt.setString(4, numAdr);
      pstmt.setString(5, rue);
      pstmt.setString(6, ville);
      pstmt.setString(7, pays);
      pstmt.setString(8, tel);
      pstmt.executeUpdate();
      pstmt.close();
    }
    catch (SQLException e) 
    {
      System.err.println(e.getMessage());
    }
  }

  public static void ajouterProduit (int proid, String desc, float prix)
                                                               throws SQLException
  {
    String sql = "INSERT INTO PRODUIT VALUES (?,?,?)";
    try
    {
      Connection conn = DriverManager.getConnection("jdbc:default:connection:");
      PreparedStatement pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, proid);
      pstmt.setString(2, desc);
      pstmt.setFloat(3, prix);
      pstmt.executeUpdate();
      pstmt.close();
    }
    catch (SQLException e)
    {
      System.err.println(e.getMessage());
    }
  }

  public static void entrerCommande (int coid, int cid, String dateCommande,
    String dateLivraison) throws SQLException 
  {
    String sql = "INSERT INTO COMMANDE VALUES (?,?,?,?)";
    try
    {
      Connection conn = DriverManager.getConnection("jdbc:default:connection:");
      PreparedStatement pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, coid);
      pstmt.setInt(2, cid);
      pstmt.setDate(3,java.sql.Date.valueOf(dateCommande));
      pstmt.setDate(4, java.sql.Date.valueOf(dateLivraison));
      pstmt.executeUpdate();
      pstmt.close();
    }
    catch (SQLException e)
    {
      System.err.println(e.getMessage());
    }
  }

  public static void ajouterLigne (int ligneid, int coid, int proid,
		  int qnt, float remise) throws SQLException
  {
    String sql = "INSERT INTO LIGNE_COMMANDE VALUES (?,?,?,?,?)";
    try
    {
      Connection conn = DriverManager.getConnection("jdbc:default:connection:");
      PreparedStatement pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, ligneid);
      pstmt.setInt(2, coid);
      pstmt.setInt(3, proid);
      pstmt.setInt(4, qnt);
      pstmt.setFloat(5, remise);
      pstmt.executeUpdate();
      pstmt.close();
    }
    catch (SQLException e)
    {
      System.err.println(e.getMessage());
    }
  }

  public static void calculerTotal () throws SQLException 
  {
    String sql = "SELECT C.CO_ID, ROUND(SUM(P.PRIX * L.QNT)) AS TOTAL " +
     "FROM COMMANDE C, LIGNE_COMMANDE L, PRODUIT P " +
     "WHERE L. CO_ID = C.CO_ID AND L.PRO_ID = P. PRO_ID "
     + "GROUP BY C.CO_ID";
    try
    {
      Connection conn = DriverManager.getConnection("jdbc:default:connection:");
      PreparedStatement pstmt = conn.prepareStatement(sql);
      ResultSet rset = pstmt.executeQuery();
      printResults(rset);
      rset.close();
      pstmt.close();
    }
    catch (SQLException e)
    {
      System.err.println(e.getMessage());
    }
  }

 
  public static void supprimerCommande (int coid) throws SQLException
  {
    String sql = "DELETE FROM LIGNE_COMMANDE WHERE CO_ID = ?";
    try
    {
      Connection conn = DriverManager.getConnection("jdbc:default:connection:");
      PreparedStatement pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, coid);
      pstmt.executeUpdate();
      sql = "DELETE FROM COMMANDE WHERE CO_ID = ?";
      pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, coid);
      pstmt.executeUpdate();
      pstmt.close();
    }
    catch (SQLException e)
    {
      System.err.println(e.getMessage());
    }
  }

static void printResults (ResultSet rset) throws SQLException
{
  String buffer = "";
  try
  {
    ResultSetMetaData meta = rset.getMetaData();
    int cols = meta.getColumnCount(), rows = 0;
    for (int i = 1; i <= cols; i++)
    {
      int size = meta.getPrecision(i);
      String label = meta.getColumnLabel(i);
      if (label.length() > size)
        size = label.length();
      while (label.length() < size)
        label += " ";
      buffer = buffer + label + " ";
    }
    buffer = buffer + "\n";
    while (rset.next())
    {
      rows++;
      for (int i = 1; i <= cols; i++)
      {
        int size = meta.getPrecision(i);
        String label = meta.getColumnLabel(i);
        String value = rset.getString(i);
        if (label.length() > size) 
          size = label.length();
        while (value.length() < size)
          value += " ";
        buffer = buffer + value + " ";
      }
      buffer = buffer + "\n";
    }
    if (rows == 0)
      buffer = "No data found!\n";
    System.out.println(buffer);
  }
  catch (SQLException e)
  {
    System.err.println(e.getMessage());
  }
}
}