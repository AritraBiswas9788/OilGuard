package com.example.oil_guard

import android.content.Intent
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity: FlutterActivity()
{
    private val CHANNEL = "flutter.native/helper"
    private var mapId: Int? = null


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "map#addKML") {
                writekmlToFile(call.arguments as String)
                val kmlData = getKMLResource();
                val kmlDatalog = loadKMLFromResource(kmlData);
                run {
                    result.success(kmlData);
                }
            } else
                if (call.method == "map#removeKML")
                {
                    //writekmlToFile(call.arguments as String)
                    val kmlData = getKMLemptyResource();
                    val kmlDatalog = loadKMLFromResource(kmlData);
                    run {
                        result.success(kmlData);
                    }
                }
            else
            {
                result.notImplemented();
            }
        }
    }

    private fun writekmlToFile(data: String)
    {
        val file = File(context.filesDir,"drone_path.kml");
        FileOutputStream(file).use { outputStream ->
            outputStream.write(data.toByteArray())
        }
    }

    private fun loadKMLFromResource(resourceId: Int): String {
        val inputStream = context.resources.openRawResource(resourceId)
        return inputStream.bufferedReader().use { it.readText() }
        //return "<?xml version=\"1.0\" encoding=\"UTF-8\"?> <kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:kml=\"http://www.opengis.net/kml/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">  <Document id=\"slave_1\">  <Style id=\"lineStyle\">      <LineStyle>        <color>7fffffff</color>        <width>4</width>      </LineStyle>      <PolyStyle>        <color>7f00ff00</color>      </PolyStyle>    </Style>    <Style id=\"polyStyle\">      <LineStyle>        <width>3</width>        <color>ffff5500</color>      </LineStyle>      <PolyStyle>        <color>a1ffaa00</color>      </PolyStyle>    </Style>    <Style id=\"main\">    <IconStyle>             <color>ff00ff00</color>                         <Icon>                <href>http://maps.google.com/mapfiles/kml/pal3/icon21.png</href>             </Icon>          </IconStyle></Style>  <Placemark>  <name>poly-gon</name>  <description>  from map  </description>  <styleUrl>#polyStyle</styleUrl>  <Polygon>  <extrude>1</extrude>  <tessellate>1</tessellate>  <outerBoundaryIs>  <LinearRing>  <coordinates>-98.34605544805527,52.145309504770125,250 -99.35471758246422,35.478021944179275,250 -128.3109760656953,54.91249544923158,250 -117.22733370959757,66.20724099238332,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 -98.34605544805527,52.145309504770125,250 </coordinates>  </LinearRing>  </outerBoundaryIs>  </Polygon>  </Placemark>  </Document></kml>";
    }

    private fun getKMLResource(): Int {
        return R.raw.drone_path;
    }
    private  fun getKMLemptyResource():Int {
        return R.raw.clear;
    }
}
