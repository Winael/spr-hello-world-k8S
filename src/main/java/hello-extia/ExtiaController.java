package hello;

import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ExtiaController {

    private static final String template = "Extia : D'abord %s, ensuite %s !";
    private final AtomicLong counter = new AtomicLong();

    @RequestMapping("/extia")
    public Extia extia(@RequestParam(value="name", defaultValue="Qui") String name) {
	if (name != null) {
            return new Extia(counter.incrementAndGet(),
                                String.format(template, name, "Extia"));
	} else {
	    return new Extia(counter.incrementAndGet(),
			        String.format(template, name, "Quoi"));
       }
    }
}
