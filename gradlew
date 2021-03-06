package sirecsa.mybposmobile

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.TransactionManager
import org.jetbrains.exposed.sql.transactions.transaction
import sirecsa.mybposmobile.almacenamiento.registerSqlDroidDriver
import sirecsa.mybposmobile.usuarios.UsuariosTable
import java.sql.Connection
import java.sql.Driver
import java.sql.DriverManager
import java.sql.SQLException

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        try {
            DriverManager.registerDriver(Class.forName("org.sqlite.JDBC").newInstance() as Driver)
        } catch (e: Exception) {
            throw RuntimeException("Failed to register org.sqlite.JDBC")
        }

        try {
            // create a database connection
            var connection = DriverManager.getConnection("jdbc:sqlite:${this.filesDir}/test.db")
            val statement = connection.createStatement()
            statement.setQueryTimeout(30)  // set timeout to 30 sec.

            statement.executeUpdate("drop table if exists person")
            statement.executeUpdate("create table person (id integer, name string)")
            statement.executeUpdate("insert into person values(1, 'leo')")
            statement.executeUpdate("insert into person values(2, 'yui')")
            val rs = statement.executeQuery("select * from person")
            while (rs.next()) {
                // read the result set
                Log.d("AppDebug", "name = " + rs.getString("name"))
                Log.d("AppDebug", "id = " + rs.getInt("id"))
            }
        } catch (e: SQLException) {
            // if the error message is "out of memory",
            // it probably means no database file is found
            Log.d("AppDebug", e.localizedMessage)
        }


        val dbPath = "${this.filesDir}/localStorage.db"
        this.deleteDatabase(dbPath)
        this.openOrCreateDatabase(dbPath, MODE_PRIVATE, null)

        Database.connect("jdbc:sqlite:$dbPath", "org.sqlite.JDBC")
        TransactionManager.manager.defaultIsolationLevel = Connection.TRANSACTION_SERIALIZABLE
        Log.d("AppDebug", dbPath)

        transaction {
            //SchemaUtils.create(UsuariosTable)
            val id = Persons.insert {
                it[id] = 5
                it[name] = "TEST"
            } get Persons.id

            /*val usuarioId = UsuariosTable.insert {
                it[usuario] = "USUTEST"
                it[idteller] = 1
            } get UsuariosTable.usuario*/
        }
    }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          