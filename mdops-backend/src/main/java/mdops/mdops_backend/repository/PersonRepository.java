package mdops.mdops_backend.repository;

import mdops.mdops_backend.entity.Person;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface PersonRepository extends JpaRepository<Person, Long> {
}
