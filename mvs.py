#!/usr/bin/env python3

import random
import sys

type Key = tuple[str, ...]
type Model = dict[Key, list[str]]


def train(text: str, n: int) -> Model:
    words = text.split()
    model: Model = {}
    for i in range(len(words) - n):
        key = tuple(words[i : i + n])
        value = words[i + n]
        model.setdefault(key, []).append(value)
    return model


def generate(model: Model, length: int, prompt: Key) -> str:
    key = prompt if prompt else random.choice(list(model.keys()))
    output = list(key)
    for _ in range(length - len(key)):
        values = model.get(key)
        if not values:
            break
        next_word = random.choice(values)
        output.append(next_word)
        key = *key[1:], next_word
    return " ".join(output)


def main(n: int, length: int, prompt: Key) -> None:
    model = train(open("book.txt").read(), n)
    print(generate(model, length, prompt[:n]))


if __name__ == "__main__":
    main(
        int(sys.argv[1]) if len(sys.argv) > 1 else 2,
        int(sys.argv[2]) if len(sys.argv) > 2 else 100,
        tuple(sys.argv[3].split()) if len(sys.argv) > 3 else (),
    )
