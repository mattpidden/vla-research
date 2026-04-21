I started this week by reading papers, blog posts and watching videos to figure out why the VLA models are not performing as I expected.
https://ggando.com/blog/smolvla-so101/
From ggando's blog he said its very important to have a consistent movement in your demos. I know in our block pick and place we did a lot of diferent picking methods.
Perhaps a good idea is to train on 100 epsidoes with low variance first, then finetune. Then add more data with expanded varaince and continue the fine tuneing. 
I also noted there is no large standard so101 dataset available like the DROID dataset. I wonder if its worth creating that.
Also ive realised we're using the SO-101 arm wrong with the camera on the side not on the top of the wrist.
https://huggingface.co/blog/nxp/bringing-robotics-ai-to-embedded-platforms
