package mdops.mdops_backend.controller;

import lombok.RequiredArgsConstructor;
import mdops.mdops_backend.entity.Person;
import mdops.mdops_backend.repository.PersonRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/persons")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class PersonController {

    private final PersonRepository repo;

    @GetMapping
    public List<Person> getAll() {
        return repo.findAll();
    }

    @PostMapping
    public Person create(@RequestBody Person person) {
        return repo.save(person);
    }
}