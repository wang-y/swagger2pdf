package com.cmfun.swagger2pdf;

import io.github.swagger2markup.GroupBy;
import io.github.swagger2markup.Language;
import io.github.swagger2markup.Swagger2MarkupConfig;
import io.github.swagger2markup.Swagger2MarkupConverter;
import io.github.swagger2markup.builder.Swagger2MarkupConfigBuilder;
import io.github.swagger2markup.markup.builder.MarkupLanguage;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.test.autoconfigure.restdocs.AutoConfigureRestDocs;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

@RunWith(SpringRunner.class)
@AutoConfigureRestDocs(outputDir = "target/asciidoc/snippets")
public class Swagger2MarkupTest {

    private RestTemplate restTemplate = new RestTemplate();

    @Test
    public void createSpringfoxSwaggerJson() throws Exception {
        String baseurl = System.getProperty("custom.baseurl");
        String group = System.getProperty("custom.group");
        String swaggerUrl = "http://" + baseurl + "/v2/api-docs"+((group!=null&&group.length()>0)?("?group="+group):"");
        String outputDir = System.getProperty("io.springfox.staticdocs.outputDir");
        System.out.println("swaggerUrl: " + swaggerUrl);
        System.out.println("outputDir: " + outputDir);

        String swaggerJson = restTemplate.getForObject(swaggerUrl, String.class);

        Files.createDirectories(Paths.get(outputDir));

        try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(outputDir, "swagger.json"), StandardCharsets.UTF_8)) {
            writer.write(swaggerJson);
        } catch (Exception e) {
            e.printStackTrace();
        }

        Swagger2MarkupConfig config = new Swagger2MarkupConfigBuilder()
                .withMarkupLanguage(MarkupLanguage.MARKDOWN)
                .withOutputLanguage(Language.ZH)
                .withPathsGroupedBy(GroupBy.TAGS)
                .build();
        Swagger2MarkupConverter converter = Swagger2MarkupConverter.from(Paths.get(outputDir, "swagger.json")).withConfig(config).build();
        converter.toFile(Paths.get(outputDir,"swagger"));
    }
}