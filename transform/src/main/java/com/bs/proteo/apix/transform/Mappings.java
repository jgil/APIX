package com.bs.proteo.apix.transform;

import com.bs.proteo.tools.MultiMap;

import java.io.*;

public class Mappings {

    // Mapping file
    private static final String MAPFILE = "/tmp/mapfile";

    // Checking period for modificatons in mapping file
    private static final long CHECKPERIOD = 5 * 60 * 1000;

    // key1:  source namespace
    // key2:  target namespace
    // value: routing key
    private static MultiMap<String, String, String> mappings = null;

    // Last checking time
    private static long lastCheckTime ;

    // Modification time of current loaded mapping file
    private static long lastModificationMappingFile;

    protected static synchronized void loadMappings() {
        MultiMap<String, String, String> workingMap = new MultiMap<String, String, String>();
        BufferedReader br = null;

        try {
            br = new BufferedReader(new FileReader(MAPFILE));
            String line;
            while ((line = br.readLine()) != null) {
                String[] mapconfig = line.split(",");
                workingMap.put(mapconfig[0], mapconfig[1], mapconfig[2]);
            }
        } catch (FileNotFoundException e) {
            throw new RuntimeException("Mapping file " + MAPFILE + " not found.");
        } catch (IOException e) {
            throw new RuntimeException("Error reading mapping file " + MAPFILE);
        } finally {
            if (br != null) try {
                br.close();
            } catch (IOException e) {
                throw new RuntimeException("Error closing mapping file " + MAPFILE);
            }
        }

        mappings = workingMap;
    }

    protected static void getMappings() {
        long currentTime = System.currentTimeMillis();
        File file = new File(MAPFILE);
        long lastModif = file.lastModified();

        if (mappings == null) {
            loadMappings();
            lastModificationMappingFile = lastModif;
        }
        else {
            if (currentTime - lastCheckTime > CHECKPERIOD)
            {
                if (lastModif > lastModificationMappingFile)
                {
                    loadMappings();
                    lastModificationMappingFile = lastModif;
                }
            }
        }
        lastCheckTime = currentTime;
    }

    public static String getTargetNamespace(String sourceNamespace) {
        getMappings();
        String targetNamespace = mappings.getKey2ByKey1(sourceNamespace);
        if (targetNamespace == null)
            throw new RuntimeException("Source namespace unknown.");

        System.out.println(sourceNamespace + " >> " + targetNamespace);
        return targetNamespace;
    }

    public static String getSourceNamespace(String targetNamespace) {
        getMappings();
        String sourceNamespace = mappings.getKey1ByKey2(targetNamespace);
        if (sourceNamespace == null)
            throw new RuntimeException("Target namespace unknown.");

        System.out.println(targetNamespace + " >> " + sourceNamespace);
        return sourceNamespace;
    }

    public static String getRoutingKey(String sourceNamespace) {
        getMappings();
        String routingKey = mappings.getValueByKey1(sourceNamespace);
        if (routingKey == null)
            throw new RuntimeException("Source namespace unknown.");

        System.out.println(sourceNamespace + " >> " + routingKey);
        return routingKey;
    }
}