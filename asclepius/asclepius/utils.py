from timeit import default_timer as timer
from contextlib import contextmanager
import logging

__all__ = ['timing']


@contextmanager
def timing(description):
    logging.info(f"Timing {description}")
    start = timer()
    yield
    end = timer()
    duration = end - start
    logging.info(f"Finished {description} ({duration:0.3f} s)")
