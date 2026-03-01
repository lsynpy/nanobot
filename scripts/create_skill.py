import os
import sys
from pathlib import Path


def main():
    skill_name = os.environ.get("SKILL_NAME")

    if not skill_name:
        if len(sys.argv) > 1:
            skill_name = sys.argv[1]
        else:
            skill_name = input("Enter skill name: ")

    skill_dir = Path(".agents/skills") / f"pawpsicle-{skill_name}"
    skill_dir.mkdir(parents=True, exist_ok=True)

    skill_file = skill_dir / "SKILL.md"
    skill_file.touch()

    print(f"Created skill: pawpsicle-{skill_name}")


if __name__ == "__main__":
    main()
